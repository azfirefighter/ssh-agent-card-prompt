# vim:ts=8

CC	?= cc
CFLAGS	?= -O2
CFLAGS	+= -Wall -Wunused -Wmissing-prototypes -Wstrict-prototypes -Wunused \
		-Wpointer-sign
#CFLAGS	+= -g

PREFIX	?= /usr/local
BINDIR	?= $(PREFIX)/bin
MANDIR	?= $(PREFIX)/man/man1

INSTALL_PROGRAM ?= install -s
INSTALL_DATA ?= install

X11BASE	?= /usr/X11R6
INCLUDES?= -I$(X11BASE)/include -I$(X11BASE)/include/freetype2
LDPATH	?= -L$(X11BASE)/lib
LIBS	+= -lX11 -lXft

PROG	= ssh-agent-card-prompt
OBJS	= ssh-agent-card-prompt.o

all: $(PROG)

$(PROG): $(OBJS)
	$(CC) $(OBJS) $(LDPATH) $(LIBS) -o $@

$(OBJS): *.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

README.md: $(PROG).1
	mandoc -T markdown $(PROG).1 > README.md

install: all
	mkdir -p $(DESTDIR)$(BINDIR)
	$(INSTALL_PROGRAM) $(PROG) $(DESTDIR)$(BINDIR)
	mkdir -p $(DESTDIR)$(MANDIR)
	$(INSTALL_DATA) -m 644 ${PROG}.1 $(DESTDIR)$(MANDIR)/${PROG}.1

clean:
	rm -f $(PROG) $(OBJS)

.PHONY: all install clean
