######################################################################
#              DreanWolf/SDL DC update                                  #
######################################################################
#																	 #
#																	 #
#								  Makefile (c)2020 from Ian Micheal  #
######################################################################

# Files ---------------------------------------------------------------------------
#

TARGET = wolf3d.elf
BIN = wolf3d.bin
FIRSTREAD = wolf3d_scr.bin
# Optimize -------------------------------------------------------------------------
OPT= -O3 -Wall -ffast-math 
 
# Defines -------------------------------------------------------------------------
KOS_LOCAL_CFLAGS =  -DDREAMCAST -DMAX_MEM_LEVEL -DSDL -DLSB_FIRST -DALIGN_LONG -DINLINE -DDC -DUCHAR_MAX=0xff -DUSHRT_MAX=0xffff -DULONG_MAX=0xffffffff
KOS_CFLAGS += $(OPT)
# Files ---------------------------------------------------------------------------
OBJS =  dc_main.o dc_vmu.o fmopl.o  id_ca.o id_in.o id_pm.o id_sd.o id_us_1.o id_vh.o id_vl.o signon.o wl_act1.o wl_act2.o wl_agent.o wl_atmos.o wl_cloudsky.o wl_debug.o wl_draw.o  wl_floorceiling.o wl_game.o  wl_inter.o wl_main.o wl_menu.o wl_parallax.o wl_play.o wl_state.o wl_text.o

KOS_CFLAGS += -I${KOS_BASE}/../kos-ports/include/SDL

all: rm-elf $(TARGET)
# Base ----------------------------------------------------------------------------
include $(KOS_BASE)/Makefile.rules

clean:
	-rm -f $(TARGET) $(BIN) $(FIRSTREAD) $(OBJS) romdisk.*

rm-elf:
	-rm -f $(TARGET) romdisk.*
# Link ----------------------------------------------------------------------------
$(TARGET): $(OBJS) romdisk.o
	$(KOS_CC) $(KOS_CFLAGS) $(KOS_LDFLAGS) -o $(TARGET) $(KOS_START) \
		$(OBJS) romdisk.o $(OBJEXTRA) -L$(KOS_BASE)/lib -lSDL_mixer_126 -lSDL_129 -lz_123 -lm   $(KOS_LIBS)
# ROM Disk Creation ---------------------------------------------------------------
romdisk.img:
	$(KOS_GENROMFS) -f romdisk.img -d romdisk -v

romdisk.o: romdisk.img
	$(KOS_BASE)/utils/bin2o/bin2o romdisk.img romdisk romdisk.o

run: $(TARGET)
	$(KOS_LOADER) $(TARGET)
# ELF2BIN ---------------------------------------------------------------------------
dist:
	rm -f $(OBJS) romdisk.o romdisk.img
	$(KOS_STRIP) $(TARGET)
	$(KOS_CC_BASE)/bin/sh-elf-objcopy -O binary $(TARGET) $(BIN)
	$(KOS_CC_BASE)/bin/sh-elf-scramble $(BIN) $(FIRSTREAD)
	cp $(FIRSTREAD) 1st_read.bin

