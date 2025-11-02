# picosmac

![RAC-Snoopy title image](https://github.com/nyholku/picosmac/blob/main/rca-snoopy.JPG?raw=true)

PICOSMAC is a Cosmac VIP emulator for PIC18F4550.

It emulates both the RCA COSMAC CDP1802 processors as well as the CDP1861 video display
running in realtime at emulated clock speed of 1.75 MHz producing NTSC compatible video signal.

The emulator includes the original COSMAC ROM and CHIP8 interpreter and some of the
original games, but it also runs CDP1802 machine code and given the right hardware you should be able
even load old COSMAC programs from C-cassette tapes!

For more info refer to an [artile published in Nuts and Volts](https://www.nutsvolts.com/magazine/article/picosmac-back-to-the-past).

To use the code you just need to program the ```cosmac.hex``` file
it into a PIC18F4550 with PICKit 2 or something similar.


![PICOSMAC Schematics](https://github.com/nyholku/picosmac/blob/main/schematics.png?raw=true)

To re-compile the code you will need ```gputils```, the development was done
on macOS so Linux compilation may require small tweaks, on Windows maybe more
is required.

All the code need to simulate 1802/1861 is in the src/ folder.

The ```src/cosmac``` folder contains CHIP8 games that used to come with COSMAC ELF
in the bygone days. These are included with the ```cosmac.hex``` file
and can be run by holding one of the keys 1-9 while resetting the PIC.

Holding down C while resetting will enter the COSMAC monitor program.

The ```java/``` folder contains a few tools that were used when I developed the
PICOSMAC emulator.

The most important one is the regression test tool which creates test
cases both in  1802 and PIC assembly language, compiles and runs them
and the compares the results. This was used to ensure that any mods
will not break the PICOSMAC emulator.

To compile and run the whole test set from command line you can do:
```
javac -d bin src/cosmac/*.java
java -cp bin cosmac.Main
```

The 1802 Java emulator is automatically generated and can be regenerated
by running the ```Gen1802SimuJavaCode().run()```, see ```cosmac.Main.java```
 for an example.

Of interest maybe also class MakeChip8 which converts .ch8 hex code
to format digestible for ```gpasm``` to be included with PICOSMAC emulator.

The class CDP1802Assembler contains a trivial assembler/disassembler that
the regression test uses and which I used during the development.

The ```Chip8Simu``` class contains some code that creates an instance of the Java
1802 simulator, loads the COSMAC monitor ROM and CHIP8 interpreter into
the simulator RAM and executes it, this was/can be used to debug
CHIP8 related problems.

All of the Java code is included for completeness sake and as an
historical artefact, no further usage is expected.
