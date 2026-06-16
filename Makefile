PLUGIN_NAME := autonetworktester
BUILD_DIR   := build
SRC_DIR     := src
INCLUDE_DIR := include

# DevkitPro/Wii U environment paths
DEVKITPRO  ?= /opt/devkitpro
DEVKITPPC  ?= $(DEVKITPRO)/devkitPPC

# Toolchain definitions
CC         := $(DEVKITPPC)/bin/powerpc-eabi-g++
OBJCOPY    := $(DEVKITPPC)/bin/powerpc-eabi-objcopy

# Compiler flags for Position Independent Code
CFLAGS := -O2 -Wall -std=c++17 \
          -D__WIIU__ \
          -fPIC \
          -frtti -fno-exceptions \
          -I$(INCLUDE_DIR) \
          -I$(DEVKITPRO)/wut/include \
          -I$(DEVKITPRO)/wups/include \
          -I$(DEVKITPRO)/wums/include

# Linker flags for a shared relocatable plugin module
LDFLAGS := -shared -pie -Wl,-export-dynamic \
           -L$(DEVKITPRO)/wut/lib \
           -L$(DEVKITPRO)/wups/lib \
           -L$(DEVKITPRO)/wums/lib \
           -lwups -lwut -lnotifications

# Source files
SRCS := $(SRC_DIR)/main.cpp \
        $(SRC_DIR)/net.cpp \
        $(SRC_DIR)/Notification.cpp

# Object files
OBJS := $(SRCS:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)

# Outputs
ELF    := $(BUILD_DIR)/$(PLUGIN_NAME).elf
OUTPUT := $(BUILD_DIR)/$(PLUGIN_NAME).wps

# -------------------------------
# Compilation Rules
# -------------------------------

all: $(OUTPUT)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Step 1: Compile .cpp source files into relocatable object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Step 2: Link object files into the intermediate shared ELF binary
$(ELF): $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) -o $@

# Step 3: Package the ELF into the final working Wii U Plugin (.wps)
# WUPS plugins use standard ELF structures but require a stripped/adjusted format
$(OUTPUT): $(ELF)
	$(OBJCOPY) --strip-unneeded -O elf32-powerpc $< $@

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean