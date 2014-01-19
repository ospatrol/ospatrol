# Makefile for monitord 
# Daniel B. Cid <dcid@ossec.net>

PT=../
NAME=ospatrol-monitord

include ../Config.Make

LOCAL = compress_log.c main.c manage_files.c monitor_agents.c monitord.c sign_log.c generate_reports.c ../os_maild/sendcustomemail.c

OBJS = ${OS_CONFIG} ${OS_SHARED} ${OS_NET} ${OS_REGEX} ${OS_XML} ${OS_CRYPTO} ${OS_ZLIB}

mmonitor:
		${CC} ${CFLAGS} ${OS_LINK} ${LOCAL} ${OBJS} -o ${NAME}
		${CC} ${CFLAGS} ${OS_LINK} -UARGV0 -DARGV0=\"ospatrol-reportd\" report.c ${OBJS} -o ospatrol-reportd
clean:
		${CLEAN}
		rm -f ospatrol-reportd
build:
		${BUILD}
		cp -pr ospatrol-reportd ${PT}../bin
