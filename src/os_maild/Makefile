# Makefile for maild
# Daniel B. Cid <dcid@ossec.net>

PT=../
NAME=ospatrol-maild

include ../Config.Make

LOCAL = maild.c config.c os_maild_client.c sendmail.c mail_list.c

OBJS = ${OS_CONFIG} ${OS_SHARED} ${OS_NET} ${OS_REGEX} ${OS_XML}

maild:
		${CC} ${CFLAGS} ${OS_LINK} ${LOCAL} ${OBJS} -o ${NAME}
clean:
		${CLEAN}
build:
		${BUILD}
