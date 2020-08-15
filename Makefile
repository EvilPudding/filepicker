CC = cc
LD = cc
AR = ar

emscripten: CC = emcc
emscripten: LD = emcc
emscripten: AR = emar

DEPS = $(shell pkg-config --libs gtk+-3.0)

DEPS_EMS = 

DIR = build

SRCS = filepicker.c

NFDS = nativefiledialog/src
NFD_SRCS = $(wildcard $(NFDS)/*.c)

NFDO = nativefiledialog/build/obj/x64/Release/nfd
NFD_OBJS = $(patsubst $(NFDS)/%.c, $(NFDO)/%.o, $(NFD_SRCS))

OBJS_REL = $(patsubst %.c, $(DIR)/%.o, $(SRCS)) $(NFD_OBJS)
OBJS_DEB = $(patsubst %.c, $(DIR)/%.debug.o, $(SRCS)) $(NFD_OBJS)
OBJS_EMS = $(patsubst %.c, $(DIR)/%.emscripten.o, $(SRCS))

CFLAGS = -Wuninitialized $(PARENTCFLAGS) -I../candle -Inativefiledialog/src/include

CFLAGS_REL = $(CFLAGS) -O3

CFLAGS_DEB = $(CFLAGS) -g3

CFLAGS_EMS = $(CFLAGS) -O3

##############################################################################

all: $(DIR)/libs

$(DIR)/libs: $(DIR)/export.a
	echo $(DEPS) filepicker.candle/$< > $@

$(NFDO)/%.o:
	$(MAKE) -C nativefiledialog/build/gmake_linux

$(DIR)/export.a: init $(OBJS_REL)
	$(AR) rs build/export.a $(OBJS_REL)

$(DIR)/%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS_REL)

##############################################################################

debug: $(DIR)/libs_debug

$(DIR)/libs_debug: $(DIR)/export_debug.a
	echo $(DEPS) mpv.candle/$< > $@

$(DIR)/export_debug.a: init $(OBJS_DEB)
	$(AR) rs build/export_debug.a $(OBJS_DEB)

$(DIR)/%.debug.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS_DEB)

##############################################################################

emscripten: $(DIR)/libs_emscripten

$(DIR)/libs_emscripten: $(DIR)/export_emscripten.a
	echo $(DEPS_EMS) filepicker.candle/$< > $@

$(DIR)/export_emscripten.a: init $(OBJS_EMS)
	$(AR) rs build/export_emscripten.a $(OBJS_EMS)

$(DIR)/%.emscripten.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS_EMS)

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

