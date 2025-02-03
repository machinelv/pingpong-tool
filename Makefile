CC=mpicc
CFLAGS=-O3 -std=c99
LIBS=

all: pingpong1 pingpong2


pingpong1: pingpong.c
	$(CC) $(CFLAGS) -o $@ $< $(LIBS)

pingpong2: pingpong.c
	$(CC) $(CFLAGS) -o $@ $< $(LIBS)

clean:
	rm pingpong
