
"Headless Doom" is a benchmark/test program based on Doom. I have used
it for testing compilers, CPU simulators, FPGA hardware, timing analysis
software and a coverage testing tool. It is written in C, with some GCC
extensions, and is portable to any 32/64-bit platform supported by
GCC or Clang.

![Partially-rendered frame from E1M3](pic.png)

Over nearly ten years, I used versions of "Headless Doom" on 
x86 Linux, x64 Linux, x86 Windows, Microblaze (bare metal), Android and 
ARM Linux (RPi, RPi model 2, and Pandaboard). It uses the original 
source code release from id Software, with some bug fixes and 
modifications of my own. This source code is demo-compatible with
the original DOS game and renders the game at the original 320x200
resolution.


Jack Whitham, April 2015



# Requirements:

To run the benchmark or the test, you will need Ultimate Doom.
This should contain the "doom.wad" data file, with md5 sum:

    c4fe9fd920207691a9f493668e0a2083  doom.wad

For more details of this file see:
http://www.wad-archive.com/wad/The-Ultimate-Doom-v1.9u

The benchmark and test both make use of "Doom Done Quick", a speedrun
that completes all 32 non-secret levels in under 20 minutes. The original
"DdQ-1941.zip" archive is included. For more details of DdQ, see:
http://quake.speeddemosarchive.com/quake/qdq/movies/ddq.html



# Instructions:

Run "make" to compile.

Run "./benchmark.exe" to run the benchmark. This runs through 32 levels
of the game by playing the "Doom Done Quick" demo, then exits. As a final
step, the program prints the total time that elapsed. The program does not 
use your computer's real-time clock: all frames are rendered, regardless
of CPU speed.

Run "./test.exe" to run the test. This does the same thing as the benchmark,
but also computes the CRC-32 of each frame rendered, and compares this 
against a "known good" list. As a result it's significantly slower. This
mode can be used to detect subtle software and hardware errors.



# Typical benchmark timings (benchmark.exe):

    Platform                     Compiler        Typical time

    RPi 2 (ARMv7 1GHz)           GCC 4.6.3       77.3s
    RPi (ARMv6 700MHz)           GCC 4.6.3       217.1s
    Linux x86 (Core2 E8600)      GCC 4.7.2       10.3s
    Linux x64 (Core2 E8600)      GCC 4.7.2       9.4s
    Windows x86 (Core i5 2500)   GCC 4.7.4       6.8s
    Linux x64 (Core i3 3220)     GCC 4.7.2       6.9s
    Linux x86 (Core i3 3220)     GCC 4.1.2       7.5s
    Linux PowerPC (E500)         GCC 4.9.2       81.4s
    Android 6.0 (Snapdragon 410) Clang 3.9.0     69.3s
    W10 Linux x64 (AMD A6-6310)  GCC 4.8.4       17.1s

    (test.exe typically requires 25% more time)


# Videos:

The Doom Done Quick demo may be watched here:
   https://www.youtube.com/watch?v=oZGRL8-bhhw

(This is not a recording of Headless Doom, which spends less time on the
title screens etc.)

Doom's rendering process is shown here:
   https://www.youtube.com/watch?v=ujXrQVyl610

(This is Headless Doom running on a PowerPC E500 with execution slowed by
a factor of 16667, so that 60 microseconds of CPU time is one second of
video time. You can see how the game draws the walls, floor and sprites. See
also: http://blog.jwhitham.org/2016/03/a-detailed-timing-trace-with-video.html )


