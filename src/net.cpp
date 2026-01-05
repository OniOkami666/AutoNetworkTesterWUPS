// Made by Oniokami666

#include <coreinit/thread.h>
#include <coreinit/time.h>
#include <coreinit/debug.h>
#include <coreinit/screen.h>
#include <nn/ac.h>

// common printing configuration for the wii u
void Print(const char* msg) {
    OSScreenInit();

    OSScreenClearBufferEx(SCREEN_TV, 0);
    OSScreenPutFontEx(SCREEN_TV, 10, 10, msg);
    OSScreenFlipBuffersEx(SCREEN_TV);
}

bool AutoNetinit() {
    nn::ac::Initialize();
    OSSleepTicks(OSMillisecondsToTicks(100));
    // result comes from the connect function and returns 0 if successful and -1 if failed
    nn::Result ret = nn::ac::Connect();

    if (ret != 0) {
        Print("Wi-Fi initialization failed!");
        return false;
    }
    Print("Connecting to the internet...");
    OSSleepTicks(OSMillisecondsToTicks(500));

    nn::ac::Status stats;
    nn::Result stat = nn::ac::GetConnectStatus(&stats);

    if(stat == 0) {
        Print("Connection Successful!");
        return true;
    }
    else if (stat < 0) {
        Print("Connection Failed!");
        return false;
    }
}

void AutoNetdeinit() {
    nn::ac::CloseAll();
    nn::ac::Finalize();
}