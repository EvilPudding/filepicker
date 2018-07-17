CC = cc
LD = cc

DEPS = $(shell pkg-config --libs gtk+-3.0)

DIR = build

SRCS = filepicker.c

NFD = nativefiledialog/build/obj/x64/Release/nfd/

OBJS_REL = $(patsubst %.c, $(DIR)/%.o, $(SRCS)) $(wildcard $(NFD)/*.o)
OBJS_DEB = $(patsubst %.c, $(DIR)/%.debug.o, $(SRCS)) $(wildcard $(NFD)/*.o)

CFLAGS = -Wuninitialized $(PARENTCFLAGS) -I../candle -Inativefiledialog/src/include

CFLAGS_REL = $(CFLAGS) -O3

CFLAGS_DEB = $(CFLAGS) -g3

##############################################################################

all: $(DIR)/export.a
	echo $(DEPS) > $(DIR)/deps

$(NFD)/nfd_gtk.o:
	$(MAKE) -C nativefiledialog/build/gmake_linux

$(DIR)/export.a: init $(OBJS_REL)
	$(AR) rs build/export.a $(OBJS_REL)

$(DIR)/%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS_REL)

##############################################################################

debug: $(DIR)/export_debug.a
	echo $(DEPS) > $(DIR)/deps

$(DIR)/export_debug.a: init $(OBJS_DEB)
	$(AR) rs build/export_debug.a $(OBJS_DEB)

$(DIR)/%.debug.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS_DEB)

##############################################################################

init:
	git submodule update
	mkdir -p $(DIR)

##############################################################################

clean:
	-rm -r $(DIR)
	$(MAKE) -C nativefiledialog/build/gmake_linux clean

# vim:ft=make
#

