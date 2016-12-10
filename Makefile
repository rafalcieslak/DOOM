CC= mipsel-unknown-elf-gcc -mips32r2 -EL
CFLAGS2= -DMIMIKER -DHEADLESS -O0 -g -Wall  $(CFLAGS)
LDFLAGS= -T ../mimiker.ld
LIBS= -lc -lgcc ../syscalls.o -lc ../start.o

# subdirectory for objects
O=headless_doom

EMBED_BENCH_NAME = DOOM_benchmark

# not too sophisticated dependency
OBJS=				\
		$(O)/doomdef.o		\
		$(O)/doomstat.o		\
		$(O)/dstrings.o		\
		$(O)/i_system.o		\
		$(O)/i_sound.o		\
		$(O)/i_net.o			\
		$(O)/tables.o			\
		$(O)/f_finale.o		\
		$(O)/f_wipe.o 		\
		$(O)/d_main.o			\
		$(O)/d_net.o			\
		$(O)/d_items.o		\
		$(O)/g_game.o			\
		$(O)/m_menu.o			\
		$(O)/m_misc.o			\
		$(O)/m_argv.o  		\
		$(O)/m_bbox.o			\
		$(O)/m_fixed.o		\
		$(O)/m_swap.o			\
		$(O)/m_cheat.o		\
		$(O)/m_random.o		\
		$(O)/am_map.o			\
		$(O)/p_ceilng.o		\
		$(O)/p_doors.o		\
		$(O)/p_enemy.o		\
		$(O)/p_floor.o		\
		$(O)/p_inter.o		\
		$(O)/p_lights.o		\
		$(O)/p_map.o			\
		$(O)/p_maputl.o		\
		$(O)/p_plats.o		\
		$(O)/p_pspr.o			\
		$(O)/p_setup.o		\
		$(O)/p_sight.o		\
		$(O)/p_spec.o			\
		$(O)/p_switch.o		\
		$(O)/p_mobj.o			\
		$(O)/p_telept.o		\
		$(O)/p_tick.o			\
		$(O)/p_saveg.o		\
		$(O)/p_user.o			\
		$(O)/r_bsp.o			\
		$(O)/r_data.o			\
		$(O)/r_draw.o			\
		$(O)/r_main.o			\
		$(O)/r_plane.o		\
		$(O)/r_segs.o			\
		$(O)/r_sky.o			\
		$(O)/r_things.o		\
		$(O)/w_wad.o			\
		$(O)/wi_stuff.o		\
		$(O)/v_video.o		\
		$(O)/st_lib.o			\
		$(O)/st_stuff.o		\
		$(O)/hu_stuff.o		\
		$(O)/hu_lib.o			\
		$(O)/s_sound.o		\
		$(O)/z_zone.o			\
		$(O)/info.o				\
		$(O)/sounds.o           \
        $(O)/i_main.o

all: benchmark.uelf benchmark.uelf.o test.uelf \
    doom.wad.ok DDQ-EP1.LMP DDQ-EP2.LMP DDQ-EP3.LMP DDQ-EP4.LMP

benchmark.uelf: $(OBJS) $(O)/i_video_benchmark.o
	$(CC) -o benchmark.uelf $(OBJS) $(O)/i_video_benchmark.o $(LDFLAGS) $(CFLAGS) $(LIBS)

test.uelf: $(OBJS) $(O)/crc.o $(O)/i_video_test.o
	$(CC) -o test.uelf $(OBJS) $(LDFLAGS) $(O)/crc.o $(O)/i_video_test.o $(CFLAGS) $(LIBS)

doom.wad:
	@echo ""
	@echo "doom.wad not found. Please copy 'doom.wad' from Ultimate Doom."
	@echo "See README.txt"
	@echo ""
	@false

doom.wad.ok: doom.wad
	md5sum -c doom.wad.md5
	touch doom.wad.ok

DDQ-EP1.LMP:
	unzip -o DdQ-1941.zip

DDQ-EP2.LMP: DDQ-EP1.LMP
DDQ-EP3.LMP: DDQ-EP2.LMP
DDQ-EP4.LMP: DDQ-EP3.LMP

clean:
	rm -f $(O)/*.o *~ *.flc test.uelf benchmark.uelf *.i doom.wad.ok DDQ*

$(O)/%.o:	$(O)/%.c
	$(CC) $(CFLAGS2) -c $< -o $@

benchmark.uelf.o: benchmark.uelf Makefile
	mipsel-unknown-elf-objcopy -I binary --rename-section .data=.rodata,contents,readonly,data -O elf32-little --alt-machine-code=8 $< $@
	mipsel-unknown-elf-objcopy --redefine-sym _binary_benchmark_uelf_start=_binary_$(EMBED_BENCH_NAME)_uelf_start $@
	mipsel-unknown-elf-objcopy --redefine-sym _binary_benchmark_uelf_end=_binary_$(EMBED_BENCH_NAME)_uelf_end $@
	mipsel-unknown-elf-objcopy --redefine-sym _binary_benchmark_uelf_size=_binary_$(EMBED_BENCH_NAME)_uelf_size $@
