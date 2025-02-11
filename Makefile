CC=mpicc
CFLAGS=-O3 -std=c99
LIBS=

pingpong_msg_size ?= 102400

all: pingpong1 pingpong2

pingpong1: pingpong.c
	$(CC) $(CFLAGS) -o $@ $< $(LIBS) -DPINGPONG_MSG_SIZE=$(pingpong_msg_size)

pingpong2: pingpong.c
	$(CC) $(CFLAGS) -o $@ $< $(LIBS) -DPINGPONG_MSG_SIZE=$(pingpong_msg_size)

clean:
	rm pingpong pingpong1 pingpong2
