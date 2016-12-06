-----------------------------------------------------------------------------------------------------------------

NOTES:

The following library was written by Ulrich Drepper in 1995.  It is an implementation of the MD5 algorithm as
defined by RFC 1321.  See the rfc1321.txt file which should have been included with this release.

It was then hacked up a bit by Gray Watson to improve code readability (at least to me) as well as to improve
its overall functionality.  The basic algorithm is quite magic and was not touched of course.

See the md5.h header file for the function prototypes and comments.  My apologies for the minimal
documentation.

-----------------------------------------------------------------------------------------------------------------

INSTALL:

1) Type ``configure'' to run the configuration script to generate the Makefile.

2) Typing ``make'' should be enough to build the library.

3) Typing ``make tests'' will build and run the md5_t test program.

4) You can also run the test program as ``md5_t -r filename'' to get a md5 signature on a file.

5) Typing ``md5_t -r -'' will generate a signature on the data read from standard in.

-----------------------------------------------------------------------------------------------------------------

REPOSITORY:

The newest versions of the library are available on the web.

	http://256.com/sources/md5/

-----------------------------------------------------------------------------------------------------------------

If you have any questions or problems feel free to send me mail.

Gray Watson
http://256.com/gray/

-----------------------------------------------------------------------------------------------------------------
$Id: README.txt,v 1.2 2010-05-07 15:14:58 gray Exp $
-----------------------------------------------------------------------------------------------------------------
