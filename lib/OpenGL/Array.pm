package OpenGL::Array;

use 5.008000;
use strict;
use warnings;

require Exporter;
require DynaLoader;

our @ISA = qw(Exporter DynaLoader);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use OpenGL::Array ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

# require XSLoader;
# XSLoader::load('OpenGL::Array', $VERSION);

bootstrap OpenGL::Array;

*OpenGL::Array::CLONE_SKIP  = sub { 1 };  # OpenGL::Array  is not thread safe
*OpenGL::Matrix::CLONE_SKIP = sub { 1 };  # OpenGL::Matrix is not thread safe

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

OpenGL::Array - Perl extension for blah blah blah

=head1 SYNOPSIS

  use OpenGL::Array;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for OpenGL::Array, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

U-NAE\chris.h.marshall, E<lt>chris.h.marshall@nonetE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2017 by U-NAE\chris.h.marshall

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.22.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
