# TODO: Source some file to get compiler version, etc.
# TODO: Use timer

CC = gcc
C_VERSION = c99

SOURCE_FILES := $(wildcard oscore-test/*.c) $(wildcard shared/*.c)
SOURCE_FILES := $(filter-out oscore-test/ut_oscore_test_arinc653.c oscore-test/ut_oscore_test_vxworks.c, $(SOURCE_FILES))

CFLAGS = -std=$(C_VERSION) -DOS_USE_EMBEDDED_PRINTF -DLOG_TO_STDOUT_TOO -DCOMPOSITE_OS -fno-stack-protector -c -I ../bsp/pc-composite/config -I ./shared -I ../os/inc

all:
	$(CC) $(CFLAGS) $(SOURCE_FILES)
