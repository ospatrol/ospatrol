# Makefile for the compiled rules
# Daniel B. Cid <dcid@ossec.net>
# http://www.ossec.net

PT=../../
NAME=ospatrol-analysisd

include ../../Config.Make


plugins:
		./register_rule.sh build
		$(CC) $(CFLAGS) -I../ -c $(SOURCES)

clean:
		-${CLEAN}
