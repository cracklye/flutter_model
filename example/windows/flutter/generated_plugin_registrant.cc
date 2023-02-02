//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <cbl_flutter_ce/cbl_flutter_ce.h>
#include <desktop_drop/desktop_drop_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  CblFlutterCeRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("CblFlutterCe"));
  DesktopDropPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopDropPlugin"));
}
