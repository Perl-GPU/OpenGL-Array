/*  Last saved: Mon 07 Aug 2017 04:53:34 PM */

/*  Copyright (c) 1998 Kenneth Albanowski. All rights reserved.
 *  Copyright (c) 2007 Bob Free. All rights reserved.
 *  Copyright (c) 2009 Chris Marshall. All rights reserved.
 *  This program is free software; you can redistribute it and/or
 *  modify it under the same terms as Perl itself.
 */

#include <stdio.h>

#include "pgopogl.h"

#ifdef HAVE_GL
#include "gl_util.h"

/* Note: this is caching procs once for all contexts */
/* !!! This should instead cache per context */
#if defined(_WIN32) || (defined(__CYGWIN__) && defined(HAVE_W32API))
#define loadProc(proc,name) \
{ \
  if (!proc) \
  { \
    proc = (void *)wglGetProcAddress(name); \
    if (!proc) croak(name " is not supported by this renderer"); \
  } \
}
#define testProc(proc,name) ((proc) ? 1 : !!(proc = (void *)wglGetProcAddress(name)))
#else /* not using WGL */
#define loadProc(proc,name)
#define testProc(proc,name) 1
#endif /* not defined _WIN32, __CYGWIN__, and HAVE_W32API */
#endif /* defined HAVE_GL */


/********************/
/* GPGPU Utils      */
/********************/

GLint FBO_MAX = -1;

/* Get max GPGPU data size */
int gpgpu_size(void)
{
#if defined(GL_ARB_texture_rectangle) && defined(GL_ARB_texture_float) && \
  defined(GL_ARB_fragment_program) && defined(GL_EXT_framebuffer_object)
  if (FBO_MAX == -1)
  {
    if (testProc(glProgramStringARB,"glProgramStringARB") &&
      testProc(glGenProgramsARB,"glGenProgramsARB") &&
      testProc(glBindProgramARB,"glBindProgramARB") &&
      testProc(glIsProgramARB,"glIsProgramARB") &&
      testProc(glProgramLocalParameter4fvARB,"glProgramLocalParameter4fvARB") &&
      testProc(glDeleteProgramsARB,"glDeleteProgramsARB") &&
      testProc(glGenFramebuffersEXT,"glGenFramebuffersEXT") &&
      testProc(glGenRenderbuffersEXT,"glGenRenderbuffersEXT") &&
      testProc(glBindFramebufferEXT,"glBindFramebufferEXT") &&
      testProc(glFramebufferTexture2DEXT,"glFramebufferTexture2DEXT") &&
      testProc(glBindRenderbufferEXT,"glBindRenderbufferEXT") &&
      testProc(glRenderbufferStorageEXT,"glRenderbufferStorageEXT") &&
      testProc(glFramebufferRenderbufferEXT,"glFramebufferRenderbufferEXT") &&
      testProc(glCheckFramebufferStatusEXT,"glCheckFramebufferStatusEXT") &&
      testProc(glDeleteRenderbuffersEXT,"glDeleteRenderbuffersEXT") &&
      testProc(glDeleteFramebuffersEXT,"glDeleteFramebuffersEXT"))
    {
      glGetIntegerv(GL_MAX_RENDERBUFFER_SIZE_EXT,&FBO_MAX);
    }
    else
    {
      FBO_MAX = 0;
    }
  }
  return(FBO_MAX);
#else
  return(0);
#endif
}

/* Get max square array width for a given GPGPU data size */
int gpgpu_width(int len)
{
  int max = gpgpu_size();
  if (max && len && !(len%3))
  {
    int count = len / 3;
    int w = (int)sqrt(count);

    while ((w <= count) && (w <= max))
    {
      if (!(count%w)) return(w);
      w++;
    }
  }
  return(0);
}

#ifdef GL_ARB_fragment_program
static char affine_prog[] =
  "!!ARBfp1.0\n"
  "PARAM affine[4] = {program.local[0..3]};\n"
  "TEMP decal;\n"
  "TEX decal, fragment.texcoord[0], texture[0], RECT;\n"
  "MOV decal.w, 1.0;\n"
  "DP4 result.color.x, decal, affine[0];\n"
  "DP4 result.color.y, decal, affine[1];\n"
  "DP4 result.color.z, decal, affine[2];\n"
  "END\n";

/* Enable affine shader program */
void enable_affine(oga_struct * oga)
{
  if (!oga) return;
  if (!oga->affine_handle)
  {
    /* Load shader program */
    glGenProgramsARB(1,&oga->affine_handle);
    glBindProgramARB(GL_FRAGMENT_PROGRAM_ARB,oga->affine_handle);
    glProgramStringARB(GL_FRAGMENT_PROGRAM_ARB,
      GL_PROGRAM_FORMAT_ASCII_ARB, strlen(affine_prog),affine_prog);

    /* Validate shader program */
    if (!glIsProgramARB(oga->affine_handle))
    {
      GLint errorPos;
      glGetIntegerv(GL_PROGRAM_ERROR_POSITION_ARB,&errorPos);
      if (errorPos < 0) errorPos = strlen(affine_prog);
      croak("Affine fragment program error\n%s",&affine_prog[errorPos]);
    }
  }
  glEnable(GL_FRAGMENT_PROGRAM_ARB);
}

/* Disable affine shader program */
void disable_affine(oga_struct * oga)
{
  if (!oga) return;
  if (oga->affine_handle) glDisable(GL_FRAGMENT_PROGRAM_ARB);
}
#endif

#ifdef GL_EXT_framebuffer_object
/* Unbind an FBO to an OGA */
void release_fbo(oga_struct * oga)
{
  if (oga->fbo_handle)
  {
    glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
    glDeleteFramebuffersEXT(1,&oga->fbo_handle);
  }

  if (oga->tex_handle[0] || oga->tex_handle[1])
  {
    glBindTexture(oga->target,0);	
    if (oga->tex_handle[0]) glDeleteTextures(1,&oga->tex_handle[0]);
    if (oga->tex_handle[1]) glDeleteTextures(1,&oga->tex_handle[1]);
  }
}

/* Enable an FBO bound to an OGA */
void enable_fbo(oga_struct * oga, int w, int h, GLuint target,
  GLuint pixel_type, GLuint pixel_format, GLuint element_size)
{
  if (!oga) return;

  if ((oga->fbo_w != w) || (oga->fbo_h != h) ||
    (oga->target != target) ||
    (oga->pixel_type != pixel_type) ||
    (oga->pixel_format != pixel_format) ||
    (oga->element_size != element_size)) release_fbo(oga);

  if (!oga->fbo_handle)
  {
    GLenum status;

    /* Save params */
    oga->fbo_w = w;
    oga->fbo_h = h;
    oga->target = target;
    oga->pixel_type = pixel_type;
    oga->pixel_format = pixel_format;
    oga->element_size = element_size;

    /* Set up FBO */
    glGenTextures(2,oga->tex_handle);
    glGenFramebuffersEXT(1,&oga->fbo_handle);
    glBindFramebufferEXT(GL_FRAMEBUFFER_EXT,oga->fbo_handle);

    glViewport(0,0,w,h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(0,w,0,h);
    glMatrixMode(GL_MODELVIEW); 
    glLoadIdentity();

    glBindTexture(target,oga->tex_handle[1]);
    glTexParameteri(target,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
    glTexParameteri(target,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
    glTexParameteri(target,GL_TEXTURE_WRAP_S,GL_CLAMP);
    glTexParameteri(target,GL_TEXTURE_WRAP_T,GL_CLAMP);

    glTexImage2D(target,0,pixel_type,w,h,0,
      pixel_format,element_size,0);

    glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT,
      GL_COLOR_ATTACHMENT0_EXT,target,oga->tex_handle[1],0);

    status = glCheckFramebufferStatusEXT(GL_RENDERBUFFER_EXT);
    if (status) croak("enable_fbo status: %04X\n",status);
  }
  else
  {
    glBindFramebufferEXT(GL_FRAMEBUFFER_EXT,oga->fbo_handle);
  }

  /* Load data */
  glBindTexture(target,oga->tex_handle[0]);
  glTexImage2D(target,0,pixel_type,w,h,0,
    pixel_format,element_size,oga->data);

  glEnable(target);
  //glDrawBuffer(GL_COLOR_ATTACHMENT0_EXT);
  glBindTexture(target,oga->tex_handle[0]);
  glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_DECAL);
}

/* Disable an FBO bound to an OGA */
void disable_fbo(oga_struct * oga)
{
  if (!oga) return;
  if (oga->fbo_handle)
  {
    glDisable(oga->target);
    glBindFramebufferEXT(GL_FRAMEBUFFER_EXT,0);
  }
}
#endif

MODULE = OpenGL::Array		PACKAGE = OpenGL::Array

#//# glpHasGPGPU();
int
glpHasGPGPU()
	CODE:
		RETVAL = gpgpu_size();
	OUTPUT:
		RETVAL
