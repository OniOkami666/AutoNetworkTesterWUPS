# Compiler (absolute path from your environment)
CXX := /opt/devkitpro/devkitPPC/bin/powerpc-eabi-g++

# Compiler flags
CXXFLAGS := -O2 -mhard-float -m32 -Wall -fno-exceptions -ffunction-sections -fdata-sections -fno-rtti -std=c++17

# Linker flags
LDFLAGS := -Wl,-Map,AutoNetTester.map -Wl,--gc-sections -nostartfiles

# Include paths
INCLUDES := -I./include \
            -I/opt/devkitpro/wups/include \
            -I/opt/devkitpro/wut/include \
            -I/opt/devkitpro/wut/include/coreinit \
            -I/opt/devkitpro/devkitPPC/include \
            -I/opt/devkitpro/portlibs/ppc/include

# Source files
SRC := src/net.cpp src/main.cpp
OBJ := $(SRC:.cpp=.o)

# Output
TARGET := AutoNetTester.rpx

# ==============================
# Build rules
# ==============================

all: $(TARGET)

# Compile each .cpp into .o
%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Link object files into .rpx
$(TARGET): $(OBJ)
	$(CXX) $(OBJ) $(LDFLAGS) -o $@

# Clean build files
clean:
	rm -f $(OBJ) $(TARGET)

# Optional: show include paths
show-includes:
	@echo $(INCLUDES)