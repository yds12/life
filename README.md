# life

[Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) implemented in [Crystal](https://crystal-lang.org/) using [CrSFML](https://github.com/oprypin/crsfml/).

![Life Screenshot](/screenshot/life02.png?raw=true)

## Compiling

To build the executable, in the root directory run:

    crystal deps
    crystal build src/life.cr

In order to compile the program with the commands above you need to have crystal and CrSFML installed.

## Usage

To run:

    ./life

To change the initial configuration and size of the grid, please edit the file `board.dat`.
