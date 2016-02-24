
Some of my tasm programs. Tested under MS-DOS, FreeDOS and DOSBox.

### ekr.asm
Will draw some lines and circles on the screen, while making noises on the PC speaker. When it's done you can make some noises yourself with the home row keys, or test the experimental integer rotation algorithm by pressing W. Press X to exit.

### piano.asm
Just the homerow piano from ekr.asm separated.

### parz.asm
A simple primality test. Does not work with numbers bigger than 9276, though don't quite remeber why.

### mypm.asm
This one just says hello from protected mode.

### macrolib.asm
This is a collection of some useful macros. Though some of them are way too big.

### Building
Just use ```tasm``` and ```tlink``` to compile the programs. The build.bat does exactly that.
