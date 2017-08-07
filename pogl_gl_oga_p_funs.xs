/*  Last saved: Mon 07 Aug 2017 05:11:17 PM */

/*  Copyright (c) 1998 Kenneth Albanowski. All rights reserved.
 *  Copyright (c) 2007 Bob Free. All rights reserved.
 *  Copyright (c) 2009 Chris Marshall. All rights reserved.
 *  This program is free software; you can redistribute it and/or
 *  modify it under the same terms as Perl itself.
 */

#include <stdio.h>

#include "pgopogl.h"

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


MODULE = OpenGL::GL::OGA	PACKAGE = OpenGL::Array



#if defined(GL_VERSION_1_1) || defined(GL_EXT_vertex_array)

#//# glVertexPointerEXT_p($size, (OGA)pointer);
void
glVertexPointerEXT_p(size, oga)
	GLint	size
	OpenGL::Array oga
	INIT:
#ifndef GL_VERSION_1_1 // GL_EXT_vertex_array
		loadProc(glVertexPointerEXT,"glVertexPointerEXT");
#endif
	CODE:
	{
		GLvoid * data = oga->data;
#ifdef GL_VERSION_2_0
		glBindBuffer(GL_ARRAY_BUFFER, oga->bind);
		data = NULL;
#elif defined(GL_ARB_vertex_buffer_object)
		if (testProc(glBindBufferARB,"glBindBufferARB"))
		{
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, oga->bind);
			data = NULL;
		}
#endif
#ifdef GL_VERSION_1_1
		glVertexPointer(size, oga->types[0], 0, data);
#else // GL_EXT_vertex_array
		glVertexPointerEXT(size, oga->types[0], 0, oga->item_count/size, data);
#endif
	}

#//# glVertexPointer_p($size, (OGA)pointer);
void
glVertexPointer_p(size, oga)
	GLint	size
	OpenGL::Array oga
	INIT:
#ifndef GL_VERSION_1_1 // GL_EXT_vertex_array
		loadProc(glVertexPointerEXT,"glVertexPointerEXT");
#endif
	CODE:
	{
		GLvoid * data = oga->data;
#ifdef GL_VERSION_2_0
		glBindBuffer(GL_ARRAY_BUFFER, oga->bind);
		data = NULL;
#elif defined(GL_ARB_vertex_buffer_object)
		if (testProc(glBindBufferARB,"glBindBufferARB"))
		{
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, oga->bind);
			data = NULL;
		}
#endif
#ifdef GL_VERSION_1_1
		glVertexPointer(size, oga->types[0], 0, data);
#else // GL_EXT_vertex_array
		glVertexPointerEXT(size, oga->types[0], 0, oga->item_count/size, data);
#endif
	}


#//# glNormalPointerEXT_p((OGA)pointer);
void
glNormalPointerEXT_p(oga)
	OpenGL::Array oga
	INIT:
#ifndef GL_VERSION_1_1 // GL_EXT_vertex_array
		loadProc(glNormalPointerEXT,"glNormalPointerEXT");
#endif
	CODE:
	{
		GLvoid * data = oga->data;
#ifdef GL_VERSION_2_0
		glBindBuffer(GL_ARRAY_BUFFER, oga->bind);
		data = NULL;
#elif defined(GL_ARB_vertex_buffer_object)
		if (testProc(glBindBufferARB,"glBindBufferARB"))
		{
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, oga->bind);
			data = NULL;
		}
#endif
#ifdef GL_VERSION_1_1
		glNormalPointer(oga->types[0], 0, data);
#else // GL_EXT_vertex_array
		glNormalPointerEXT(oga->types[0], 0, oga->item_count/3, data);
#endif
	}

#//# glNormalPointer_p((OGA)pointer);
void
glNormalPointer_p(oga)
	OpenGL::Array oga
	INIT:
#ifndef GL_VERSION_1_1 // GL_EXT_vertex_array
		loadProc(glNormalPointerEXT,"glNormalPointerEXT");
#endif
	CODE:
	{
		GLvoid * data = oga->data;
#ifdef GL_VERSION_2_0
		glBindBuffer(GL_ARRAY_BUFFER, oga->bind);
		data = NULL;
#elif defined(GL_ARB_vertex_buffer_object)
		if (testProc(glBindBufferARB,"glBindBufferARB"))
		{
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, oga->bind);
			data = NULL;
		}
#endif
#ifdef GL_VERSION_1_1
		glNormalPointer(oga->types[0], 0, data);
#else // GL_EXT_vertex_array
		glNormalPointerEXT(oga->types[0], 0, oga->item_count/3, data);
#endif
	}


#//# glColorPointerEXT_p($size, (OGA)pointer);
void
glColorPointerEXT_p(size, oga)
	GLint	size
	OpenGL::Array oga
	INIT:
#ifndef GL_VERSION_1_1 // GL_EXT_vertex_array
		loadProc(glColorPointerEXT,"glColorPointerEXT");
#endif
	CODE:
	{
		GLvoid * data = oga->data;
#ifdef GL_VERSION_2_0
		glBindBuffer(GL_ARRAY_BUFFER, oga->bind);
		data = NULL;
#elif defined(GL_ARB_vertex_buffer_object)
		if (testProc(glBindBufferARB,"glBindBufferARB"))
		{
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, oga->bind);
			data = NULL;
		}
#endif
#ifdef GL_VERSION_1_1
		glColorPointer(size, oga->types[0], 0, data);
#else // GL_EXT_vertex_array
		glColorPointerEXT(size, oga->types[0], 0, oga->item_count/size, data);
#endif
	}

#//# glColorPointer_p($size, (OGA)pointer);
void
glColorPointer_p(size, oga)
	GLint	size
	OpenGL::Array oga
	INIT:
#ifndef GL_VERSION_1_1 // GL_EXT_vertex_array
		loadProc(glColorPointerEXT,"glColorPointerEXT");
#endif
	CODE:
	{
		GLvoid * data = oga->data;
#ifdef GL_VERSION_2_0
		glBindBuffer(GL_ARRAY_BUFFER, oga->bind);
		data = NULL;
#elif defined(GL_ARB_vertex_buffer_object)
		if (testProc(glBindBufferARB,"glBindBufferARB"))
		{
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, oga->bind);
			data = NULL;
		}
#endif
#ifdef GL_VERSION_1_1
		glColorPointer(size, oga->types[0], 0, data);
#else // GL_EXT_vertex_array
		glColorPointerEXT(size, oga->types[0], 0, oga->item_count/size, data);
#endif
	}


#//# glIndexPointerEXT_p((OGA)pointer);
void
glIndexPointerEXT_p(oga)
	OpenGL::Array oga
	INIT:
#ifndef GL_VERSION_1_1 // GL_EXT_vertex_array
		loadProc(glIndexPointerEXT,"glIndexPointerEXT");
#endif
	CODE:
	{
		GLvoid * data = oga->data;
#ifdef GL_VERSION_2_0
		glBindBuffer(GL_ARRAY_BUFFER, oga->bind);
		data = NULL;
#elif defined(GL_ARB_vertex_buffer_object)
		if (testProc(glBindBufferARB,"glBindBufferARB"))
		{
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, oga->bind);
			data = NULL;
		}
#endif
#ifdef GL_VERSION_1_1
		glIndexPointer(oga->types[0], 0, data);
#else // GL_EXT_vertex_array
		glIndexPointerEXT(oga->types[0], 0, oga->item_count, data);
#endif
	}

#//# glIndexPointer_p((OGA)pointer);
void
glIndexPointer_p(oga)
	OpenGL::Array oga
	INIT:
#ifndef GL_VERSION_1_1 // GL_EXT_vertex_array
		loadProc(glIndexPointerEXT,"glIndexPointerEXT");
#endif
	CODE:
	{
		GLvoid * data = oga->data;
#ifdef GL_VERSION_2_0
		glBindBuffer(GL_ARRAY_BUFFER, oga->bind);
		data = NULL;
#elif defined(GL_ARB_vertex_buffer_object)
		if (testProc(glBindBufferARB,"glBindBufferARB"))
		{
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, oga->bind);
			data = NULL;
		}
#endif
#ifdef GL_VERSION_1_1
		glIndexPointer(oga->types[0], 0, data);
#else // GL_EXT_vertex_array
		glIndexPointerEXT(oga->types[0], 0, oga->item_count, data);
#endif
	}


#//# glTexCoordPointerEXT_p($size, (OGA)pointer);
void
glTexCoordPointerEXT_p(size, oga)
	GLint	size
	OpenGL::Array oga
	INIT:
#ifndef GL_VERSION_1_1 // GL_EXT_vertex_array
		loadProc(glTexCoordPointerEXT,"glTexCoordPointerEXT");
#endif
	CODE:
	{
		GLvoid * data = oga->data;
#ifdef GL_VERSION_2_0
		glBindBuffer(GL_ARRAY_BUFFER, oga->bind);
		data = NULL;
#elif defined(GL_ARB_vertex_buffer_object)
		if (testProc(glBindBufferARB,"glBindBufferARB"))
		{
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, oga->bind);
			data = NULL;
		}
#endif
#ifdef GL_VERSION_1_1
		glTexCoordPointer(size, oga->types[0], 0, data);
#else // GL_EXT_vertex_array
		glTexCoordPointerEXT(size, oga->types[0], 0, oga->item_count/size, data);
#endif
	}

#//# glTexCoordPointer_p($size, (OGA)pointer);
void
glTexCoordPointer_p(size, oga)
	GLint	size
	OpenGL::Array oga
	INIT:
#ifndef GL_VERSION_1_1 // GL_EXT_vertex_array
		loadProc(glTexCoordPointerEXT,"glTexCoordPointerEXT");
#endif
	CODE:
	{
		GLvoid * data = oga->data;
#ifdef GL_VERSION_2_0
		glBindBuffer(GL_ARRAY_BUFFER, oga->bind);
		data = NULL;
#elif defined(GL_ARB_vertex_buffer_object)
		if (testProc(glBindBufferARB,"glBindBufferARB"))
		{
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, oga->bind);
			data = NULL;
		}
#endif
#ifdef GL_VERSION_1_1
		glTexCoordPointer(size, oga->types[0], 0, data);
#else // GL_EXT_vertex_array
		glTexCoordPointerEXT(size, oga->types[0], 0, oga->item_count/size, data);
#endif
	}


#//# glEdgeFlagPointerEXT_p((OGA)pointer);
void
glEdgeFlagPointerEXT_p(oga)
	OpenGL::Array oga
	INIT:
#ifndef GL_VERSION_1_1 // GL_EXT_vertex_array
		loadProc(glTexCoordPointerEXT,"glEdgeFlagPointerEXT");
#endif
	CODE:
	{
		GLvoid * data = oga->data;
#ifdef GL_VERSION_2_0
		glBindBuffer(GL_ARRAY_BUFFER, oga->bind);
		data = NULL;
#elif defined(GL_ARB_vertex_buffer_object)
		if (testProc(glBindBufferARB,"glBindBufferARB"))
		{
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, oga->bind);
			data = NULL;
		}
#endif
#ifdef GL_VERSION_1_1
		glEdgeFlagPointer(0, data);
#else // GL_EXT_vertex_array
		glEdgeFlagPointerEXT(0, oga->item_count, data);
#endif
	}

#//# glEdgeFlagPointer_p((OGA)pointer);
void
glEdgeFlagPointer_p(oga)
	OpenGL::Array oga
	INIT:
#ifndef GL_VERSION_1_1 // GL_EXT_vertex_array
		loadProc(glTexCoordPointerEXT,"glEdgeFlagPointerEXT");
#endif
	CODE:
	{
		GLvoid * data = oga->data;
#ifdef GL_VERSION_2_0
		glBindBuffer(GL_ARRAY_BUFFER, oga->bind);
		data = NULL;
#elif defined(GL_ARB_vertex_buffer_object)
		if (testProc(glBindBufferARB,"glBindBufferARB"))
		{
			glBindBufferARB(GL_ARRAY_BUFFER_ARB, oga->bind);
			data = NULL;
		}
#endif
#ifdef GL_VERSION_1_1
		glEdgeFlagPointer(0, data);
#else // GL_EXT_vertex_array
		glEdgeFlagPointerEXT(0, oga->item_count, data);
#endif
	}

#endif // GL_EXT_vertex_array || GL_VERSION_1_1


#ifdef GL_VERSION_1_4

#//# glBufferData_p($target,(OGA)data,$usage);
void
glBufferData_p(target,oga,usage)
	GLenum target
	OpenGL::Array oga
	GLenum usage
	CODE:
	{
		glBufferData(target,oga->data_length,oga->data,usage);
	}


#//# glBufferSubData_p($target,$offset,(OGA)data);
void
glBufferSubData_p(target,offset,oga)
	GLenum	target
	GLint	offset
	OpenGL::Array oga
	CODE:
	{
		glBufferSubData(target,offset*oga->total_types_width,oga->data_length,oga->data);
	}


#//# $oga = glGetBufferSubData_p($target,$offset,$count,@types);
#//- If no types are provided, GLubyte is assumed
OpenGL::Array
glGetBufferSubData_p(target,offset,count,...)
	GLenum	target
	GLint	offset
	GLsizei	count
	CODE:
	{
		oga_struct * oga = malloc(sizeof(oga_struct));
		GLint size;

		oga->item_count = count;
		oga->type_count = (items - 3);

				if (oga->type_count)
		{
			int i,j;

			oga->types = malloc(sizeof(GLenum) * oga->type_count);
			oga->type_offset = malloc(sizeof(GLint) * oga->type_count);
			for(i=0,j=0;i<oga->type_count;i++) {
				oga->types[i] = SvIV(ST(i+3));
				oga->type_offset[i] = j;
				j += gl_type_size(oga->types[i]);
			}
			oga->total_types_width = j;
		}
		else
		{
			oga->type_count = 1;
			oga->types = malloc(sizeof(GLenum) * oga->type_count);
			oga->type_offset = malloc(sizeof(GLint) * oga->type_count);

			oga->types[0] = GL_UNSIGNED_BYTE;
			oga->type_offset[0] = 0;
			oga->total_types_width = gl_type_size(oga->types[0]);
		}
		if (!oga->total_types_width) croak("Unable to determine type sizes\n");

		glGetBufferParameteriv(target,GL_BUFFER_SIZE,&size);
		size /= oga->total_types_width;
		if (offset > size) croak("Offset is greater than elements in buffer: %d\n",size);

		if ((offset+count) > size) count = size - offset;

		oga->data_length = oga->total_types_width * count;
		oga->data = malloc(oga->data_length);

		glGetBufferSubData(target,offset*oga->total_types_width,
			oga->data_length,oga->data);

		oga->free_data = 1;

		RETVAL = oga;
	}
	OUTPUT:
		RETVAL


#define FIXME /* !!! Need to refactor with glGetBufferPointerv_p */

#//# $oga = glMapBuffer_p($target,$access,@types);
#//- If no types are provided, GLubyte is assumed
OpenGL::Array
glMapBuffer_p(target,access,...)
	GLenum	target
	GLenum	access
	CODE:
	{
		GLsizeiptr size;
		oga_struct * oga;
		int i,j;

		void * buffer =	glMapBuffer(target,access);
		if (!buffer) croak("Unable to map buffer\n");

		glGetBufferParameteriv(target,GL_BUFFER_SIZE,(GLint*)&size);
		if (!size) croak("Buffer has no size\n");

		oga = malloc(sizeof(oga_struct));

		oga->type_count = (items - 2);

				if (oga->type_count)
		{
			oga->types = malloc(sizeof(GLenum) * oga->type_count);
			oga->type_offset = malloc(sizeof(GLint) * oga->type_count);
			for(i=0,j=0;i<oga->type_count;i++) {
				oga->types[i] = SvIV(ST(i+2));
				oga->type_offset[i] = j;
				j += gl_type_size(oga->types[i]);
			}
			oga->total_types_width = j;
		}
		else
		{
			oga->type_count = 1;
			oga->types = malloc(sizeof(GLenum) * oga->type_count);
			oga->type_offset = malloc(sizeof(GLint) * oga->type_count);

			oga->types[0] = GL_UNSIGNED_BYTE;
			oga->type_offset[0] = 0;
			oga->total_types_width = gl_type_size(oga->types[0]);
		}

		if (!oga->total_types_width) croak("Unable to determine type sizes\n");
		oga->item_count = size / oga->total_types_width;

		oga->data_length = oga->total_types_width * oga->item_count;

		oga->data = buffer;

		oga->free_data = 0;

		RETVAL = oga;
	}
	OUTPUT:
		RETVAL


#//# $oga = glGetBufferPointerv_p($target,$pname,@types);
#//- If no types are provided, GLubyte is assumed
OpenGL::Array
glGetBufferPointerv_p(target,pname,...)
	GLenum	target
	GLenum	pname
	CODE:
	{
		GLsizeiptr size;
		oga_struct * oga;
		void * buffer;
		int i,j;

		glGetBufferPointerv(target,pname,&buffer);
		if (!buffer) croak("Buffer is not mapped\n");

		glGetBufferParameteriv(target,GL_BUFFER_SIZE,(GLint*)&size);
		if (!size) croak("Buffer has no size\n");

		oga = malloc(sizeof(oga_struct));

		oga->type_count = (items - 2);

				if (oga->type_count)
		{
			oga->types = malloc(sizeof(GLenum) * oga->type_count);
			oga->type_offset = malloc(sizeof(GLint) * oga->type_count);
			for(i=0,j=0;i<oga->type_count;i++) {
				oga->types[i] = SvIV(ST(i+2));
				oga->type_offset[i] = j;
				j += gl_type_size(oga->types[i]);
			}
			oga->total_types_width = j;
		}
		else
		{
			oga->type_count = 1;
			oga->types = malloc(sizeof(GLenum) * oga->type_count);
			oga->type_offset = malloc(sizeof(GLint) * oga->type_count);

			oga->types[0] = GL_UNSIGNED_BYTE;
			oga->type_offset[0] = 0;
			oga->total_types_width = gl_type_size(oga->types[0]);
		}

		if (!oga->total_types_width) croak("Unable to determine type sizes\n");
		oga->item_count = size / oga->total_types_width;

		oga->data_length = oga->total_types_width * oga->item_count;

		oga->data = buffer;

		oga->free_data = 0;

		RETVAL = oga;
	}
	OUTPUT:
		RETVAL

#endif // GL_VERSION_1_4


#ifdef GL_ARB_vertex_buffer_object

#//# glBufferDataARB_p($target,(OGA)data,$usage);
void
glBufferDataARB_p(target,oga,usage)
	GLenum target
	OpenGL::Array oga
	GLenum usage
	INIT:
		loadProc(glBufferDataARB,"glBufferDataARB");
	CODE:
	{
		glBufferDataARB(target,oga->data_length,oga->data,usage);
	}

#//# glBufferSubDataARB_p($target,$offset,(OGA)data);
void
glBufferSubDataARB_p(target,offset,oga)
	GLenum	target
	GLint	offset
	OpenGL::Array oga
	INIT:
		loadProc(glBufferSubDataARB,"glBufferSubDataARB");
	CODE:
	{
		glBufferSubDataARB(target,offset*oga->total_types_width,oga->data_length,oga->data);
	}


#//# $oga = glGetBufferSubDataARB_p($target,$offset,$count,@types);
#//- If no types are provided, GLubyte is assumed
OpenGL::Array
glGetBufferSubDataARB_p(target,offset,count,...)
	GLenum	target
	GLint	offset
	GLsizei	count
	INIT:
		loadProc(glGetBufferSubDataARB,"glGetBufferSubDataARB");
		loadProc(glGetBufferParameterivARB,"glGetBufferParameterivARB");
	CODE:
	{
		oga_struct * oga = malloc(sizeof(oga_struct));
		GLint size;
		
		oga->item_count = count;
		oga->type_count = (items - 3);

                if (oga->type_count)
		{
			int i,j;

			oga->types = malloc(sizeof(GLenum) * oga->type_count);
			oga->type_offset = malloc(sizeof(GLint) * oga->type_count);
			for(i=0,j=0;i<oga->type_count;i++) {
				oga->types[i] = SvIV(ST(i+3));
				oga->type_offset[i] = j;
				j += gl_type_size(oga->types[i]);
			}
			oga->total_types_width = j;
		}
		else
		{
			oga->type_count = 1;
			oga->types = malloc(sizeof(GLenum) * oga->type_count);
			oga->type_offset = malloc(sizeof(GLint) * oga->type_count);

			oga->types[0] = GL_UNSIGNED_BYTE;
			oga->type_offset[0] = 0;
			oga->total_types_width = gl_type_size(oga->types[0]);
		}
		if (!oga->total_types_width) croak("Unable to determine type sizes\n");

		glGetBufferParameterivARB(target,GL_BUFFER_SIZE_ARB,&size);
		size /= oga->total_types_width;
		if (offset > size) croak("Offset is greater than elements in buffer: %d\n",size);

		if ((offset+count) > size) count = size - offset;
		
		oga->data_length = oga->total_types_width * count;
		oga->data = malloc(oga->data_length);

		glGetBufferSubDataARB(target,offset*oga->total_types_width,
			oga->data_length,oga->data);

		oga->free_data = 1;
		
		RETVAL = oga;
	}
	OUTPUT:
		RETVAL


#define FIXME /* !!! Need to refactor with glGetBufferPointervARB_p */

#//# $oga = glMapBufferARB_p($target,$access,@types);
#//- If no types are provided, GLubyte is assumed
OpenGL::Array
glMapBufferARB_p(target,access,...)
	GLenum	target
	GLenum	access
	INIT:
		loadProc(glMapBufferARB,"glMapBufferARB");
		loadProc(glGetBufferParameterivARB,"glGetBufferParameterivARB");
	CODE:
	{
		GLsizeiptrARB size;
		oga_struct * oga;
		int i,j;

		void * buffer =	glMapBufferARB(target,access);
		if (!buffer) croak("Unable to map buffer\n");

		glGetBufferParameterivARB(target,GL_BUFFER_SIZE_ARB,(GLint*)&size);
		if (!size) croak("Buffer has no size\n");

		oga = malloc(sizeof(oga_struct));

		oga->type_count = (items - 2);

                if (oga->type_count)
		{
			oga->types = malloc(sizeof(GLenum) * oga->type_count);
			oga->type_offset = malloc(sizeof(GLint) * oga->type_count);
			for(i=0,j=0;i<oga->type_count;i++) {
				oga->types[i] = SvIV(ST(i+2));
				oga->type_offset[i] = j;
				j += gl_type_size(oga->types[i]);
			}
			oga->total_types_width = j;
		}
		else
		{
			oga->type_count = 1;
			oga->types = malloc(sizeof(GLenum) * oga->type_count);
			oga->type_offset = malloc(sizeof(GLint) * oga->type_count);

			oga->types[0] = GL_UNSIGNED_BYTE;
			oga->type_offset[0] = 0;
			oga->total_types_width = gl_type_size(oga->types[0]);
		}

		if (!oga->total_types_width) croak("Unable to determine type sizes\n");
		oga->item_count = size / oga->total_types_width;

		oga->data_length = oga->total_types_width * oga->item_count;
		
		oga->data = buffer;

		oga->free_data = 0;
		
		RETVAL = oga;
	}
	OUTPUT:
		RETVAL


#//# $oga = glGetBufferPointervARB_p($target,$pname,@types);
#//- If no types are provided, GLubyte is assumed
OpenGL::Array
glGetBufferPointervARB_p(target,pname,...)
	GLenum	target
	GLenum	pname
	INIT:
		loadProc(glGetBufferPointervARB,"glGetBufferPointervARB");
		loadProc(glGetBufferParameterivARB,"glGetBufferParameterivARB");
	CODE:
	{
		GLsizeiptrARB size;
		oga_struct * oga;
		void * buffer;
		int i,j;

		glGetBufferPointervARB(target,pname,&buffer);
		if (!buffer) croak("Buffer is not mapped\n");

		glGetBufferParameterivARB(target,GL_BUFFER_SIZE_ARB,(GLint*)&size);
		if (!size) croak("Buffer has no size\n");

		oga = malloc(sizeof(oga_struct));

		oga->type_count = (items - 2);

                if (oga->type_count)
		{
			oga->types = malloc(sizeof(GLenum) * oga->type_count);
			oga->type_offset = malloc(sizeof(GLint) * oga->type_count);
			for(i=0,j=0;i<oga->type_count;i++) {
				oga->types[i] = SvIV(ST(i+2));
				oga->type_offset[i] = j;
				j += gl_type_size(oga->types[i]);
			}
			oga->total_types_width = j;
		}
		else
		{
			oga->type_count = 1;
			oga->types = malloc(sizeof(GLenum) * oga->type_count);
			oga->type_offset = malloc(sizeof(GLint) * oga->type_count);

			oga->types[0] = GL_UNSIGNED_BYTE;
			oga->type_offset[0] = 0;
			oga->total_types_width = gl_type_size(oga->types[0]);
		}

		if (!oga->total_types_width) croak("Unable to determine type sizes\n");
		oga->item_count = size / oga->total_types_width;
		
		oga->data_length = oga->total_types_width * oga->item_count;
		
		oga->data = buffer;

		oga->free_data = 0;
		
		RETVAL = oga;
	}
	OUTPUT:
		RETVAL

#endif // GL_ARB_vertex_buffer_object
