import 'package:example/dailyaction/screen/dailyaction_list_single_page.dart';
import 'package:example/notes/screen/note_list_single_page.dart';
import 'package:example/routes/app_navigator.dart';
import 'package:example/screens/size_util.dart';
import 'package:example/screens/util_enum_ext.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<CustomNavigationItem> getNavigationItems() {
    List<CustomNavigationItem> rtn = [];

    rtn.add(CustomNavigationItem(
      const Icon(Icons.map),
      const Icon(Icons.map_outlined),
      ("Daily action"),

      /// (c) => GlobalPageMap(),
      (c) => DailyActionScreenListPage(),
    ));

    rtn.add(CustomNavigationItem(
      const Icon(Icons.note),
      const Icon(Icons.note_outlined),
      ("NOte"),

      /// (c) => GlobalPageMap(),
      (c) => NotesScreenListSinglePage(),
    ));

    return rtn;
  }

  @override
  Widget build(BuildContext context) {
    return Material3Layout(navigation: getNavigationItems());
  }

  Widget buildContent(BuildContext context) {
    return const Text("Hi");
  }
}

class Material3Layout extends StatefulWidget {
  final List<CustomNavigationItem> navigation;

  const Material3Layout({
    super.key,
    required this.navigation,
  });

  @override
  State<Material3Layout> createState() => _Material3LayoutState();
}

class Material3NewButton extends StatelessWidget {
  final bool compact;
  final List<CustomNavigationItemCreate>? options;

  const Material3NewButton({super.key, this.compact = true, this.options});

  @override
  Widget build(BuildContext context) {
    if (options == null) return Container();
    List<CustomNavigationItemCreate> option = options!;

    if (option.length == 1) {
      if (compact) {
        return IconButton(
            onPressed: () => option[0].onSelect(context),
            icon: const Icon(Icons.add));
      } else {
        return OutlinedButton(
            onPressed: () => option[0].onSelect(context),
            child: Text(option[0].label));
      }
    } else if (option.length > 1) {
      return Row(
        children: [
          if (compact)
            IconButton(
                onPressed: () => option[0].onSelect(context),
                icon: const Icon(Icons.add)),
          if (!compact)
            OutlinedButton(
                onPressed: () => option[0].onSelect(context),
                child: Text(option[0].label)),
          // IconButton(
          //     onPressed: () => options[0].onSelect(context),
          //     icon: const Icon(Icons.add)),
          PopupMenuButton<CustomNavigationItemCreate>(
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: (e) => e.onSelect(context),
            itemBuilder: (BuildContext context) {
              return option.map((CustomNavigationItemCreate choice) {
                return PopupMenuItem<CustomNavigationItemCreate>(
                  value: choice,
                  child: Text(choice.label),
                );
              }).toList();
            },
          ),
        ],
      );
    }
    return Container();
  }
}

class _Material3LayoutState extends State<Material3Layout> {
  int _selectedIndex = 0;
  bool showLeading = false;
  bool showTrailing = true;
  double groupAlignment = -1.0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  Widget _buildHeaderTitle(BuildContext context, int selectedIndex) {
    return Text(widget.navigation[selectedIndex].label);
  }

  Widget _buildContent(BuildContext context, int selectedIndex) {
    return widget.navigation[selectedIndex].builder(context);
  }

  (Widget?, FloatingActionButtonLocation?) buildFab() {
    var newOptions = widget.navigation[_selectedIndex].newOptions;
    if (newOptions == null || newOptions.isEmpty) return (null, null);
    if (newOptions.length == 1) {
      return (
        FloatingActionButton.small(
          onPressed: () => newOptions.first.onSelect(context),
          child: const Icon(Icons.add),
        ),
        FloatingActionButtonLocation.endFloat
      );
      //return (null, FloatingActionButtonLocation.endFloat);
    } else {
      return (null, null);
      // return (
      //   ExpandableFab(
      //       type: ExpandableFabType.up,
      //       distance: 50,

      //       // openButtonBuilder: RotateFloatingActionButtonBuilder(
      //       //   child: const Icon(Icons.add),
      //       //   fabSize: ExpandableFabSize.small,
      //       //   foregroundColor: Colors.amber,
      //       //   backgroundColor: Colors.green,
      //       //   shape: const CircleBorder(),
      //       // ),
      //       closeButtonBuilder: FloatingActionButtonBuilder(
      //         size: 56,
      //         builder: (BuildContext context, void Function()? onPressed,
      //             Animation<double> progress) {
      //           return IconButton(
      //             onPressed: onPressed,
      //             icon: const Icon(
      //               Icons.add,
      //               size: 40,
      //             ),
      //           );
      //         },
      //       ),
      //       children: newOptions
      //           .map(
      //             (e) => FloatingActionButton.extended(
      //               heroTag: null,
      //               label: Text(e.label),
      //               onPressed: () {
      //                 e.onSelect(context);
      //                 // launchNoteAdd(context);
      //               },
      //             ),
      //           )
      //           .toList()),
      //   ExpandableFab.location
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    var form = ContextualUtil.getFormFactor(context);
    var fabOptions = form > ScreenType.handset ? null : buildFab();

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppEnvironment.isRelease ? null : Colors.red[100],
        centerTitle: true,
        title: _buildHeaderTitle(context, _selectedIndex),
        actions: const [
          // if (!AppEnvironment.isRelease) SampleDataAddIcon()
        ],
      ),

      floatingActionButton: fabOptions?.$1,
      floatingActionButtonLocation: fabOptions?.$2, //ExpandableFab.location,
      //
      drawer: const AppDrawer(),
      bottomNavigationBar:
          form <= ScreenType.handset ? buildNavigationBar(context) : null,
      body: Row(
        children: <Widget>[
          (form > ScreenType.handset)
              ? buildNavigationRail(context)
              : Container(),
          Expanded(child: _buildContent(context, _selectedIndex)),
        ],
      ),
    );
  }

  Widget buildNavigationBar(BuildContext context) {
    return NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: _selectedIndex,
        destinations: widget.navigation
            .map(
              (e) => NavigationDestination(
                icon: e.icon,
                selectedIcon: e.selectedIcon,
                label: e.label,
              ),
            )
            .toList());
  }

  Widget buildNavigationRailButton(
      BuildContext context, List<CustomNavigationItemCreate>? options) {
    return Material3NewButton(
      options: options,
      compact: ContextualUtil.getFormFactor(context) < ScreenType.desktop,
    );
  }

  Widget buildNavigationRail(BuildContext context) {
    var newOptions = widget.navigation[_selectedIndex].newOptions;

    return NavigationRail(
        extended: ContextualUtil.getFormFactor(context) == ScreenType.desktop,
        selectedIndex: _selectedIndex,
        groupAlignment: groupAlignment,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        labelType: ContextualUtil.getFormFactor(context) == ScreenType.desktop
            ? null
            : NavigationRailLabelType.all,
        leading: newOptions != null && newOptions.isNotEmpty
            ? buildNavigationRailButton(context, newOptions)
            : Container(),
        // trailing: Expanded(
        //     child: showTrailing
        //         ? IconButton(
        //             onPressed: () {
        //               // Add your onPressed code here!
        //             },
        //             icon: const Icon(Icons.add),
        //           )
        //         : Container()),
        destinations: widget.navigation
            .map(
              (e) => NavigationRailDestination(
                icon: e.icon,
                selectedIcon: e.selectedIcon,
                label: Text(e.label),
              ),
            )
            .toList());
  }
}

class CustomNavigationItemCreate {
  final String label;
  final Function(BuildContext context) onSelect;
  CustomNavigationItemCreate(this.label, this.onSelect);
}

class CustomNavigationItem {
  final Widget icon;
  final Widget selectedIcon;
  final String label;
  final Function(
    BuildContext context,
  ) builder;
  final List<CustomNavigationItemCreate>? newOptions;

  CustomNavigationItem(this.icon, this.selectedIcon, this.label, this.builder,
      [this.newOptions]);
}
