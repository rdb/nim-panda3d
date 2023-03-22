PANDA_DIR=$(shell python -c "import panda3d.core,os;print(os.path.dirname(os.path.dirname(panda3d.core.__file__)))")
NIM?=nim

.PHONY: all clean

all: test

test: test.nim panda3d/*.nim direct/*.nim direct/*/*.nim
	$(NIM) --cincludes:${PANDA_DIR}/include --cincludes:/usr/include/eigen3 --clibdir:${PANDA_DIR}/lib cpp test.nim

clean:
	rm -f test
