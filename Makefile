SRCS = $(shell find -name '*.c' && find -name '*.asm')
OBJS = $(addsuffix .o,$(basename $(SRCS)))

CC = gcc
LD = ld
AS = nasm

ASFLAGS = -f elf
CFLAGS = -m32 -Wall -g -fno-stack-protector -nostdinc
LDFLAGS = -melf_i386 --oformat binary -T linking.ld

gondor_os: $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $^

%.o: %.asm
	$(AS) $(ASFLAGS) $^ -o $@

clean:
	rm $(OBJS)
	rm gondor_os

.PHONY: clean
