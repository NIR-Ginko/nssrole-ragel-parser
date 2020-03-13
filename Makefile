.PHONY: all

all:
	ragel role.rl
	cc role.c

