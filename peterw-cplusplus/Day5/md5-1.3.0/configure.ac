#
# Process this file with autoconf to produce a configure script.
#
# Copyright 2010 by Gray Watson
#
# Permission to use, copy, modify, and distribute this software for
# any purpose and without fee is hereby granted, provided that the
# above copyright notice and this permission notice appear in all
# copies, and that the name of Gray Watson not be used in
# advertising or publicity pertaining to distribution of the
# document or software without specific, written prior permission.
#
# Gray Watson makes no representations about the suitability of the
# software described herein for any purpose.  It is provided "as is"
# without express or implied warranty.
#
# $Id: configure.ac,v 1.2 2010-05-07 15:07:37 gray Exp $
#
AC_REVISION($Revision: 1.2 $)
AC_INIT(md5, 1.3.0, [http://256.com/sources/md5/])
AC_CONFIG_SRCDIR(md5.c)
AC_CONFIG_HEADER(conf.h)

AC_MSG_NOTICE([configurations for the md5 library])

##############################################################################
# arguments

AC_PROG_CC

AC_PROG_INSTALL
AC_PROG_RANLIB

# we need this for various settings
AC_HEADER_STDC

###############################################################################

#
# check for unsigned-ness
#
AC_MSG_CHECKING([endian-ness])
AC_RUN_IFELSE([AC_LANG_SOURCE([[
int main() { int x = 1; char *s = (char *)&x; if (*s == '\001') return 0; else return 1; }
]])],
[AC_DEFINE(MD5_BIG_ENDIAN,0)  AC_MSG_RESULT([little])],
[AC_DEFINE(MD5_BIG_ENDIAN,1)  AC_MSG_RESULT([big])],
[AC_DEFINE(MD5_BIG_ENDIAN,0)  AC_MSG_RESULT([unknown, assume little])]
)

AC_CONFIG_FILES(Makefile)
AC_OUTPUT

AC_MSG_NOTICE([])
AC_MSG_NOTICE([To run the library tests, type in:])
AC_MSG_NOTICE([  make tests])
AC_MSG_NOTICE([])
