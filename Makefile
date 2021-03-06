VERSION=0.2

# change these to reflect your Lua installation
LUA_PREFIX?=/usr
LUA_VERSION?=5.1
LUAINC=$(LUA_PREFIX)/include/lua$(LUA_VERSION)
LUALIB=$(LUA_PREFIX)/lib/lua$(LUA_VERSION)
LUASHARE=$(LUA_PREFIX)/share/lua/$(LUA_VERSION)
LUABIN=$(LUA_PREFIX)/bin

# probably no need to change anything below here
CC=gcc
CFLAGS=$(INCS) $(WARN) -O2
WARN=-Wall -Wextra
INCS=-I$(LUAINC)

CDB_OBJS=cdb_init.o cdb_find.o cdb_findnext.o cdb_seq.o cdb_seek.o cdb_unpack.o cdb_make_add.o cdb_make_put.o cdb_make.o cdb_hash.o

OBJS=$(CDB_OBJS) lcdb.o
SOS=cdb.so

all: $(SOS)

$(SOS): $(OBJS)
	$(CC) -o $@ -shared $(OBJS) $(LIBS)

.PHONY: clean test distr
clean:
	rm -f $(OBJS) $(SOS) core core.* a.out

test: all
	./lunit test.lua

tar: clean
	git archive --format=tar --prefix=lua-tinycdb-$(VERSION)/ $(VERSION) | gzip > lua-tinycdb-$(VERSION).tar.gz
