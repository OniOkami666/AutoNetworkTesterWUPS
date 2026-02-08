PLUGIN_NAME := autonetworktester
BUILD_DIR   := build
SRC_DIR     := src
INCLUDE_DIR := include

DEVKITPRO  ?= /opt/devkitpro
DEVKITPPC  ?= $(DEVKITPRO)/devkitPPC

CC := $(DEVKITPPC)/bin/powerpc-eabi-g++
AR := $(DEVKITPPC)/bin/powerpc-eabi-ar

CFLAGS := -O2 -Wall -std=c++17 \
          -I$(INCLUDE_DIR) \
          -I$(DEVKITPRO)/wut/include \
          -I$(DEVKITPRO)/wups/include \
          -I$(DEVKITPRO)/wums/include \
          -fvisibility=hidden -fvisibility-inlines-hidden \
          -fno-exceptions -fno-rtti -m32 -mcpu=750

LDFLAGS := -L$(DEVKITPRO)/wut/lib \
           -L$(DEVKITPRO)/wups/lib \
           -L$(DEVKITPRO)/wums/lib \
           -lwut -lwups -lstdc++ \
           -Wl,-Ttext,0x81800000 \
           -Wl,-Map,$(BUILD_DIR)/$(PLUGIN_NAME).map

SRCS := $(SRC_DIR)/main.cpp \
        $(SRC_DIR)/net.cpp \
        $(SRC_DIR)/Notification.cpp

OBJS := $(SRCS:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)

OUTPUT := $(BUILD_DIR)/$(PLUGIN_NAME).wps

all: $(OUTPUT)

$(BUILD_DIR):
	mkdir -p $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OUTPUT): $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) -o $@

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
