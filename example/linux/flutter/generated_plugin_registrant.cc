//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <cbl_flutter_ce/cbl_flutter_ce.h>
#include <desktop_drop/desktop_drop_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) cbl_flutter_ce_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "CblFlutterCe");
  cbl_flutter_ce_register_with_registrar(cbl_flutter_ce_registrar);
  g_autoptr(FlPluginRegistrar) desktop_drop_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DesktopDropPlugin");
  desktop_drop_plugin_register_with_registrar(desktop_drop_registrar);
}
