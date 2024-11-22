APPS :=

CC := clang
CFLAGS := -g -Wall -O2
LDLIBS += -lelf -lz
LDLIBS += /usr/lib64/libbpf.a

all: drop_ping.bpf.o

$(APPS): %: %.c %.bpf.o %.skel.h
	$(CC) $(CFLAGS) $(filter %.c,$^) $(LDLIBS) -o $@

drop_ping.bpf.o: vmlinux.h

vmlinux.h:
	bpftool btf dump file /sys/kernel/btf/vmlinux format c > vmlinux.h

%.bpf.o: %.bpf.c
	$(CC) $(CFLAGS) -c -target bpf $< -o $@

%.skel.h: %.bpf.o
	bpftool gen skeleton $< > $@

clean:
	rm -f $(BPF_APPS) *.o *.skel.h
	rm -f vmlinux.h
