CC = clang
CFLAGS = -Wall -Wextra -static
TARGET = pesp-sat.out
INSTALL_DIR = /usr/local/bin
KISSAT_DIR = ./third-party/kissat
KISSAT_LIB = $(KISSAT_DIR)/build/libkissat.a

$(TARGET): src/main.c $(KISSAT_LIB)
	$(CC) $(CFLAGS) -o $(TARGET) src/main.c $(KISSAT_LIB)

$(KISSAT_LIB):
	cd $(KISSAT_DIR) && ./configure && make kissat

install: $(TARGET)
	install -m 755 $(TARGET) $(INSTALL_DIR)

clean:
	rm -f $(TARGET)

.PHONY: install clean