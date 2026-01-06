// Made by Oniokami666

#include <coreinit/thread.h>
#include <coreinit/time.h>
#include <coreinit/debug.h>
#include <coreinit/screen.h>
#include <nn/ac.h>

#include "Notification.h"

int NetMonitoring(int argc, const char **argv);

static OSThread netinitThread;
static bool Running = false;
static bool Stop = false;
static uint8_t netThreadStack[0x4000];

constexpr int AC_STATUS_SUCCESS = 0; // Connected
constexpr int AC_STATUS_CONNECTING = 1; // Connecting
constexpr int AC_STATUS_FAILED = -1; // Connection Failed


bool Net_init() {
    nn::Result init = nn::ac::Initialize();
    if (init != 0) {
        ShowNotification("[AutoNet] Wi-fi initialization failed!");
        return false;
    }
    OSSleepTicks(OSMillisecondsToTicks(100));

    nn::Result firstnetinit = nn::ac::Connect();
    if (firstnetinit != 0) {
        ShowNotification(" [AutoNet] Initial connection failed!");
        return false;
    }

    ShowNotification("[AutoNet] Wi-Fi Initialized and you're online!");
    return true;
}
int NetMonitoring(int argc, const char **argv) {
    bool lastConnected = false;
    bool lastConnecting = false;

    while (!Stop) {
        nn::ac::Status stats;
        nn::Result res = nn::ac::GetConnectStatus(&stats);

        if (res == AC_STATUS_SUCCESS) {
            if (!lastConnected) {
                ShowNotification("[AutoNet] You are connected!");
                lastConnected = true;
            }
            lastConnecting = false;
            // Sleep long when connected
            OSSleepTicks(OSMillisecondsToTicks(60 * 60 * 1000)); 
        }
        else if (res == AC_STATUS_CONNECTING) {
            if (!lastConnecting) {
                ShowNotification("[AutoNet] Connecting...");
                lastConnecting = true;
            }
            
            OSSleepTicks(OSMillisecondsToTicks(30000)); 
        }
        else { // Disconnected or failed
            if (lastConnected) {
                ShowNotification("[AutoNet] Disconnected!");
                lastConnected = false;
            }
            lastConnecting = false;

            nn::ac::Connect(); // try reconnect
            OSSleepTicks(OSMillisecondsToTicks(5000)); 
        }
    }

    Running = false;
    return 0;
}
void StartNetThread() {
    if (!Running) {
        Stop = false;
        Running = true;
        
        int argc = 0;

        OSCreateThread(&netinitThread, NetMonitoring, argc, nullptr, netThreadStack + sizeof(netThreadStack), sizeof(netThreadStack), 30, 0);

        OSResumeThread(&netinitThread);
    }
}
void StopNetThread() {
    if (Running) {
        Stop = true;
        OSJoinThread(&netinitThread, nullptr);
        Running = false;
    }
}
