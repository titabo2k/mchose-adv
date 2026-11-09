# This is a GNU Makefile, not a shell script. Shellcheck misreads make's
# $(VAR) as command substitution and flags the unquoted expansions below;
# quoting them would break the build (flags must word-split).
# shellcheck disable=SC1072,SC1073,SC2046,SC2068,SC2086,SC2035

PREFIX      ?= /usr/local
BINDIR      ?= $(PREFIX)/bin
UDEVDIR     ?= /usr/lib/udev/rules.d
USERUNITDIR ?= /usr/lib/systemd/user
DOCDIR      ?= $(PREFIX)/share/doc/mchose-adv
LICENSEDIR  ?= $(PREFIX)/share/licenses/mchose-adv

CC      ?= cc
CFLAGS  ?= -O2 -Wall -Wextra
DESTDIR ?=

.PHONY: all clean install uninstall test

all: mchose-adv

mchose-adv: src/mchose-adv.c
	$(CC) $(CFLAGS) -o $@ src/mchose-adv.c

clean:
	rm -f mchose-adv

# Deliberately no dependency on the binary: build with plain `make` first so
# that `sudo make install` never compiles anything as root.
install:
	@test -x mchose-adv || { echo "run 'make' first (as a normal user), then 'sudo make install'" >&2; exit 1; }
	install -Dm755 mchose-adv                      $(DESTDIR)$(BINDIR)/mchose-adv
	install -Dm644 packaging/70-mchose-adv.rules   $(DESTDIR)$(UDEVDIR)/70-mchose-adv.rules
	install -Dm644 packaging/mchose-adv.service    $(DESTDIR)$(USERUNITDIR)/mchose-adv.service
	install -Dm644 README.md                       $(DESTDIR)$(DOCDIR)/README.md
	install -Dm644 docs/PROTOCOL.md                $(DESTDIR)$(DOCDIR)/PROTOCOL.md
	install -Dm644 LICENSE                         $(DESTDIR)$(LICENSEDIR)/LICENSE

uninstall:
	rm -f  $(DESTDIR)$(BINDIR)/mchose-adv
	rm -f  $(DESTDIR)$(UDEVDIR)/70-mchose-adv.rules
	rm -f  $(DESTDIR)$(USERUNITDIR)/mchose-adv.service
	rm -rf $(DESTDIR)$(DOCDIR) $(DESTDIR)$(LICENSEDIR)
