PLUGIN_NAME := autonetworktester
BUILD_DIR   := build
SRC_DIR     := src
INCLUDE_DIR := include

# DevkitPro/Wii U environment
DEVKITPRO  ?= /opt/devkitpro
DEVKITPPC  ?= $(DEVKITPRO)/devkitPPC

# Toolchain
CC := $(DEVKITPPC)/bin/powerpc-eabi-g++
AR := $(DEVKITPPC)/bin/powerpc-eabi-ar

# Compiler flags
CFLAGS := -O2 -Wall -std=c++17 \
          -I$(INCLUDE_DIR) \
          -I$(INCLUDE_DIR)/notifications \
          -I$(DEVKITPRO)/wut/include \
          -I$(DEVKITPRO)/wups/include \
          -I$(DEVKITPRO)/wums/include

# Linker flags
LDFLAGS := -L$(DEVKITPRO)/wut/lib \
           -L$(DEVKITPRO)/wups/lib \
           -L$(DEVKITPRO)/wums/lib \
           -lwut -lwups -lnotifications -lstdc++ \
           -Wl,-Ttext,0x81800000

# Source files
SRCS := $(SRC_DIR)/main.cpp \
        $(SRC_DIR)/net.cpp \
        $(SRC_DIR)/Notification.cpp

# Object files
OBJS := $(SRCS:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)

# Output
OUTPUT := $(BUILD_DIR)/$(PLUGIN_NAME).wps

# -------------------------------
# Rules
# -------------------------------

all: $(OUTPUT)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Compile .cpp -> .o
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Link .o -> .wps
$(OUTPUT): $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) -o $@

# Clean build files
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean