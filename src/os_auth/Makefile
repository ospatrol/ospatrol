# Makefile for authd
# Daniel B. Cid <dcid@ossec.net>

PT=../
NAME=ospatrol-authd

include ../Config.Make

LOCAL = ssl.c 

OBJS = ${OS_CONFIG} ${OS_SHARED} ${OS_NET} ${OS_REGEX} ${OS_CRYPTO} ${OS_ZLIB} ${OPENSSLCMD}

auth1:
		${CC} ${CFLAGS} ${OS_LINK} main-server.c ${LOCAL} ../addagent/validate.c ${OBJS} -o ${NAME}
		${CC} ${CFLAGS} ${OS_LINK} main-client.c ${LOCAL} ../addagent/validate.c ${OBJS} -o agent-auth
clean:
		${CLEAN}
		rm -f ospatrol-authd
		rm -f agent-auth
build:
		${BUILD}
		cp -pr agent-auth ospatrol-authd ${PT}../bin
