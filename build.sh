nasm -f elf boot.asm -o boot.bin
ld -T linking.ld -m elf_i386 boot.bin --oformat binary -o system.out
