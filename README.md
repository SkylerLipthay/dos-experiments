# dos-experiments

This repository is a collection of 8088 assembly language programs to be run under DOS or as bootloaders (all programs compile to 510 bytes or fewer). I'm following along [Óscar Toledo G.](https://nanochess.org/)'s fascinating [*Programming Boot Sector Games*](http://www.lulu.com/shop/oscar-toledo-gutierrez/programming-boot-sector-games/paperback/product-24188564.html).

To compile, [NASM (Netwide Assembler)](https://www.nasm.us/) is required. `make.sh` is a simple bash script for these programs that uses NASM to assemble `.asm` files into `.com` files that are ready to be executed in a DOS environment (emulated or real) such as [DOSBox](https://www.dosbox.com/). (These programs can be assembled as bootloaders with some minor modifications.) For example, run `./make.sh 001-hello` to assemble `001-hello.asm` into `001-hello.com`.

Assembly files beginning with:

* `0xx-`: Adapted from the book.
* `5xx-`: My own creations.
* `lib-`: Meant to be `%include`d in other assembly files and are not meant for direct compilation.
