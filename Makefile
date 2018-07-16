CC = cc
LD = cc

DIR = build

SRCS = filepicker.c

NFD = nativefiledialog/build/obj/x64/Release/nfd/nfd_gtk.o

OBJS_REL = $(patsubst %.c, $(DIR)/%.o, $(SRCS)) $(NFD)
OBJS_DEB = $(patsubst %.c, $(DIR)/%.debug.o, $(SRCS)) $(NFD)

CFLAGS = -Wuninitialized $(PARENTCFLAGS) -Inativefiledialog/src/include

CFLAGS_REL = $(CFLAGS) -O3

CFLAGS_DEB = $(CFLAGS) -g3

##############################################################################

all: $(DIR)/export.a

$(NFD):
	$(MAKE) -C nativefiledialog/build/gmake_linux

$(DIR)/export.a: init $(OBJS_REL)
	$(AR) rs build/export.a $(OBJS_REL)

$(DIR)/%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS_REL)

##############################################################################

debug: $(DIR)/export_debug.a

$(DIR)/export_debug.a: init $(OBJS_DEB)
	$(AR) rs build/export_debug.a $(OBJS_DEB)

$(DIR)/%.debug.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS_DEB)

##############################################################################

init:
	mkdir -p $(DIR)

##############################################################################

clean:
	-rm -r $(DIR)
	$(MAKE) -C nativefiledialog/build/gmake_linux clean

# vim:ft=make
#

