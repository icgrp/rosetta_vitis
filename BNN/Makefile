.PHONY: all clean
NUM=1
all:
	$(MAKE) -C minizip
	$(MAKE) -C utils
	$(MAKE) -C accel

run:
	./accel/host.exe 10

 
clean:
	$(MAKE) -C minizip clean
	$(MAKE) -C utils clean
	$(MAKE) -C accel clean

export CRAFT_BNN_ROOT=$(CURDIR)
