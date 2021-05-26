nasm -f elf boot.asm -o boot.bin
nasm -f elf kernel.asm -o kernel.bin
ld -T linking.ld -m elf_i386 boot.bin kernel.bin --oformat binary -o system.out
