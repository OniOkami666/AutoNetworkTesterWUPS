#include <wups.h>
#include <wups/config.h>
#include <wups/config/WUPSConfigItemBoolean.h>

#include "net.h"

using namespace std;

static bool AutoConnect = true;

void changed(WUPSConfigItemBoolean* item, bool value) {
    AutoConnect = value;
}


WUPS_PLUGIN_NAME("Auto Network Tester");
WUPS_PLUGIN_DESCRIPTION("A plugin to automatically connect to the selected wifi profile");
WUPS_PLUGIN_VERSION("v1.0");
WUPS_PLUGIN_AUTHOR("Oniokami666");
WUPS_PLUGIN_LICENSE("GPL");

WUPS_USE_WUT_DEVOPTAB();
WUPS_USE_STORAGE("autonetworktester");

ON_APPLICATION_START() {
    AutoNetinit();
}
ON_APPLICATION_ENDS() {
    AutoNetdeinit();
}