/*     
    AutoNetworkTesterWUPS
    Copyright (C) 2025 Cody (OniOkami666) Shimizu

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>. 
*/

#include <coreinit/thread.h>
#include <coreinit/time.h>
#include <nn/ac.h>
#include <notifications/notifications.h>
#include "Notification.h"
#include "net.h"

static OSThread netThread;
static bool running = false;
static bool stop = false;
static uint8_t netThreadStack[0x8000]; // 32 kb

int NetMonitoring(int argc, const char **argv) {
    bool initialized = false;

    int tick = 60 * 60 * 1000;
    while (!stop) {
        if (!initialized) {
            if (nn::ac::Initialize() != 0) {
                OSSleepTicks(OSMillisecondsToTicks(5000)); // retry in 5 sec
                continue;
            }
            initialized = true;
        }

        nn::ac::Status stats;
        nn::Result res = nn::ac::GetConnectStatus(&stats);

        if (res == 0) { // Connected
            ShowNotification("[AutoNet] Connected!");
            OSSleepTicks(OSMillisecondsToTicks(tick));
        } else if (res == 1) { // Connecting
            ShowNotification("[AutoNet] Connecting...");
            OSSleepTicks(OSMillisecondsToTicks(15000));
        } else { // Disconnected / failed
            ShowNotification("[AutoNet] Not connected, retrying...");
            nn::ac::Connect();
            OSSleepTicks(OSMillisecondsToTicks(5000));
        }
    }
    running = false;
    return 0;
}


void StartNetThread() {
    if (!running) {
        stop = false;
        running = true;
        OSCreateThread(&netThread, NetMonitoring, 0, nullptr, netThreadStack + sizeof(netThreadStack), sizeof(netThreadStack), 30, 0);
        OSResumeThread(&netThread);
    }
}

void StopNetThread() {
    if (running) {
        stop = true;
        OSJoinThread(&netThread, nullptr);
        running = false;
    }
}