# Makefile for logcollector
# Daniel B. Cid <daniel.cid@gmail.com>||<daniel@underlinux.com.br>
# http://ospatrol.com

PT=../
NAME=ospatrol-logcollector

include ../Config.Make


logr_OBJS = *.c  ${OS_CONFIG} ${OS_SHARED} ${OS_XML} ${OS_REGEX} ${OS_NET} ${OS_CRYPTO} 

logcollector:
		${CC} ${CFLAGS} ${OS_LINK} -DARGV0=\"${NAME}\" ${logr_OBJS} -o ${NAME}

clean:
		${CLEAN}
build:
		${BUILD}
