
# OpSys Makefile.PL
# $Id$

use ExtUtils::MakeMaker;

WriteMakefile(
	NAME => 'OpSys',
	VERSION_FROM => 'lib/OpSys.pm',
	EXE_FILES => [ "bin/opsys" ]
);

