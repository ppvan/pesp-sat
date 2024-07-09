CC = clang
CFLAGS = -Wall -Wextra -static -g -Ithird-party/kissat/src
TARGET = pesp-sat.out
INSTALL_DIR = /usr/local/bin
KISSAT_DIR = ./third-party/kissat
KISSAT_LIB = $(KISSAT_DIR)/build/libkissat.a


SRCS = src/solver/binomial.c src/encoding/direct.c src/main.c src/solver/naive.c src/types/pesp.c src/types/vec.c
OBJS = $(SRCS:.c=.o)

$(TARGET): $(OBJS) $(KISSAT_LIB)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(KISSAT_LIB) -lm

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(KISSAT_LIB):
	cd $(KISSAT_DIR) && ./configure && make kissat

install: $(TARGET)
	install -m 755 $(TARGET) $(INSTALL_DIR)

clean:
	rm -f $(TARGET)

.PHONY: install clean