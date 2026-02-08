#include <wups.h>
#include <nn/ac.h>
#include <notifications/notifications.h>


#include "Notification.h"
#include "net.h"

// Just some configuration stuff, no need to worry about it
WUPS_PLUGIN_NAME("Auto Network Tester");
WUPS_PLUGIN_DESCRIPTION("A plugin to automatically connect to the selected wifi profile");
WUPS_PLUGIN_VERSION("v1.0");
WUPS_PLUGIN_AUTHOR("Oniokami666");
WUPS_PLUGIN_LICENSE("GPL");

ON_APPLICATION_START() {
    NotificationModule_InitLibrary();
    // StartNetThread(); 
    ShowNotification("[AutoNet] initialized!");
}

ON_APPLICATION_ENDS() {
    StopNetThread();
    NotificationModule_DeInitLibrary();
}