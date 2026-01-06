# Compiler
CC := /opt/devkitpro/devkitPPC/bin/powerpc-eabi-g++
AR := /opt/devkitpro/devkitPPC/bin/powerpc-eabi-ar

# Directories
SRC_DIR := src
BUILD_DIR := build
INCLUDE_DIRS := -Iinclude -Iinclude/notifications \
                -I/opt/devkitpro/wut/include \
                -I/opt/devkitpro/wups/include \
                -I/opt/devkitpro/wums/include

LIB_DIRS := -L/opt/devkitpro/wut/lib \
            -L/opt/devkitpro/wups/lib \
            -L/opt/devkitpro/wums/lib

LIBS := -lwut -lwups -lnotifications -lstdc++

# Compiler flags
CFLAGS := -O2 -Wall -std=c++17 $(INCLUDE_DIRS)
LDFLAGS := $(LIB_DIRS) $(LIBS) -Wl,-Ttext,0x81800000

# Source files
SRCS := $(SRC_DIR)/main.cpp \
        $(SRC_DIR)/net.cpp \
        $(SRC_DIR)/Notification.cpp

# Object files
OBJS := $(patsubst $(SRC_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(SRCS))

# Output plugin
OUTPUT := $(BUILD_DIR)/autonetworktester.wps

#--------------------------------------
# Rules
#--------------------------------------

all: $(OUTPUT)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OUTPUT): $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) -o $@
	@echo "Plugin built: $@"

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean