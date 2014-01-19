# Makefile for zlib.
# Daniel B. Cid <dcid@ossec.net>
# http://ospatrol.com

NAME=zlib
PT=../../

include ${PT}Config.Make

shared:
		${CC} -c ${CFLAGS} ${SOURCES}
		ar cru libz.a ${OBJECTS}
		ranlib libz.a
clean:
		${CLEAN} ../../headers/zlib.h ../../headers/zconf.h ../libz.a

ospatrol:
		cp -pr zlib.h zconf.h ../../headers/
		cp -pr libz.a ../
