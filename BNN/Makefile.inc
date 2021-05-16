CXX=g++
CFLAGS=-O3 -g
MINIZIP_LDFLAGS=-lminizip -laes -lz
LDFLAGS=$(MINIZIP_LDFLAGS)

AR=ar rcs
