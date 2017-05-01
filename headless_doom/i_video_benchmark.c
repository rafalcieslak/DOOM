// Emacs style mode select   -*- C++ -*-
//-----------------------------------------------------------------------------
//
// $Id:$
//
// Copyright (C) 1993-1996 by id Software, Inc.
//
// This source is available for distribution and/or modification
// only under the terms of the DOOM Source Code License as
// published by id Software. All rights reserved.
//
// The source is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// FITNESS FOR A PARTICULAR PURPOSE. See the DOOM Source Code License
// for more details.
//
// $Log:$
//
// DESCRIPTION:
//	DOOM graphics stuff for X11, UNIX.
//
//-----------------------------------------------------------------------------

#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <assert.h>

#include "d_main.h"
#include "doomstat.h"
#include "i_system.h"
#include "m_argv.h"
#include "v_video.h"

#include "crc.h"

#include "doomdef.h"

#define POINTER_WARP_COUNTDOWN 1

extern unsigned headless_count;

void I_ShutdownGraphics(void) {
}

void I_StartFrame(void) {
}

void I_GetEvents();

//
// I_StartTic
//
void I_StartTic(void) {
  /* Poll for events (calling I_GetEvent while events are in
   * the queue) and stop the mouse pointer leaving the window
   * as a dirty keep-focus hack
   */
  I_GetEvents();
}

//
// I_UpdateNoBlit
//
void I_UpdateNoBlit(void) {
  // what is this?
}

/* Scancode to event. */
event_t events_by_simple_scancodes[256] = {
    [0x1f] = (event_t){.type = ev_keydown,
                       .data1 = KEY_DOWNARROW}, // Actually, this is S!
    [0x9f] = (event_t){.type = ev_keyup,
                       .data1 = KEY_DOWNARROW}, // Actually, this is S!
};

int palette_handle;
int fb_handle;
int sc_handle;

void I_GetEvents(void) {
  if (sc_handle < 0)
    return;
  unsigned char buf[100];
  unsigned n = read(sc_handle, buf, 100);
  for (unsigned i = 0; i < n; i++) {
    if (buf[i] == 0xe0) {
      i += 2; // Skip extended for now.
      continue;
    }
    event_t ev = events_by_simple_scancodes[buf[i]];
    if (ev.data1 == 0)
      continue; // Unrecognized key

    D_PostEvent(&ev);
  }
}

void I_FinishUpdate(void) {
  lseek(fb_handle, 0, 0);
  write(fb_handle, screens[0], 320 * 200);
  headless_count++;
}
void I_ReadScreen(byte *scr) {
  memcpy(scr, screens[0], SCREENWIDTH * SCREENHEIGHT);
}

void I_SetPalette(byte *palette) {
  lseek(palette_handle, 0, 0);
  write(palette_handle, palette, 3 * 256);
}

void I_InitGraphics(void) {
  static int firsttime = 1;

  if (!firsttime)
    return;

  firsttime = 0;

  screens[0] = (unsigned char *)malloc(SCREENWIDTH * SCREENHEIGHT);
  printf("Headless Doom running in CAHIR-OS mode\n");

  palette_handle = open("/dev/vga/palette", O_WRONLY, 0);
  fb_handle = open("/dev/vga/fb", O_WRONLY, 0);
  sc_handle = open("/dev/scancode", O_RDONLY, 0);
  assert(palette_handle >= 0 && fb_handle >= 0);
}
