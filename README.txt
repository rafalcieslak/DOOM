
"Headless Doom" is a benchmark/test program based on Doom. I have used
it for testing compilers, CPU simulators, FPGA hardware, timing analysis
software and a coverage testing tool. It is written in C, with some
GCC extensions, and is portable to any 32/64-bit platform supported by GCC.
I have used it on x86 Linux, x64 Linux, x86 Windows, Microblaze (bare metal)
and ARM Linux (RPi, RPi model 2, and Pandaboard).

It uses the original source code release from id Software.



Requirements:

To run the benchmark or the test, you will need Ultimate Doom.
This should contain the "doom.wad" data file, with md5 sum:

    c4fe9fd920207691a9f493668e0a2083  doom.wad

For more details of this file see:
http://www.wad-archive.com/wad/The-Ultimate-Doom-v1.9u



Instructions:

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


