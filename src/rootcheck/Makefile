# Makefile for rootcheck
# Daniel B. Cid <daniel.cid@gmail.com>||<daniel@underlinux.com.br>

PT=../
NAME=ospatrol-rootcheck

include ../Config.Make


OBJS = check_open_ports.c check_rc_pids.c check_rc_trojans.c run_rk_check.c check_rc_dev.c check_rc_ports.c check_rc_policy.c common.c common_rcl.c win-common.c unix-process.c check_rc_files.c check_rc_readproc.c os_string.c check_rc_if.c check_rc_sys.c rootcheck.c
OBJS2 = ${OS_SHARED} ${OS_XML} ${OS_REGEX}

rootcheck:
		$(CC) $(CFLAGS) -c ${OBJS} config.c -D_GNU_SOURCE
		ar cru rootcheck_lib.a *.o
		ranlib rootcheck_lib.a
        
binary:        
		$(CC) $(CFLAGS) ${OS_LINK} ${OBJS} rootcheck-config.c ${OBJS2} -UOSPATROL -D_GNU_SOURCE -o ${NAME}
clean:
		${CLEAN} rootcheck_lib.a
build:        
