import 'package:example/app_settings.dart';
import 'package:example/dailyaction/model_dailyaction.dart';
import 'package:example/notes/model_notes.dart';
import 'package:example/screens/test_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  doLogout() {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesBloc<AppSettings>,
        PreferencesState<AppSettings>>(builder: (context, state) {
      return Drawer(
          child: Column(children: <Widget>[
        // Padding(
        //     padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
        //     child: Image.asset(
        //       "assets/app_icon_128.png",
        //       height: 150,
        //       width: 150,
        //     )),
        const Divider(),
        Expanded(
            child: ListView(children: <Widget>[
          ListTile(
            title: const Text("Home"),
            trailing: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed("/")),
          ),
          ListTile(
            title: const Text("Home"),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.of(context).pushReplacementNamed("/"),
          ),
          ListTile(
            title: const Text("DailyAction New"),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.of(context).pushNamed("/dailyaction/create"),
          ),
          ListTile(
            title: const Text("Note New"),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.of(context).pushNamed("/notes/create"),
          ),
          ListTile(
            title: const Text("Test List"),
            leading: const Icon(Icons.home),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed("/testListScreen"),
          ),
          ListTile(
            title: const Text("Note Home"),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ModelRouter.routeList<Notes>()),
          ),
          ListTile(
            title: const Text("Actions Home"),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ModelRouter.routeList<DailyAction>()),
          ),
          ListTile(
            title: const Text("Sample Home"),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ModelRouter.routeList<Sample>()),
          ),
          ListTile(
            title: const Text("Note Home Slow"),
            leading: const Icon(Icons.slow_motion_video_sharp),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed("/testslowlist"),
          ),
          ListTile(
            title: const Text("_noteListDialog"),
            leading: const Icon(Icons.slow_motion_video_sharp),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed("/_noteListDialog"),
          ),
          ListTile(
            title: const Text("_noteListPaneDialog"),
            leading: const Icon(Icons.slow_motion_video_sharp),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed("/_noteListPaneDialog"),
          ),
          ListTile(
            title: const Text("_noteListUri"),
            leading: const Icon(Icons.slow_motion_video_sharp),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed("/_noteListUri"),
          ),
          ListTile(
            title: const Text("_noteListPaneUri"),
            leading: const Icon(Icons.slow_motion_video_sharp),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed("/_noteListPaneUri"),
          ),
          const Divider(),
        ])),
      ]));
    });
  }
}
