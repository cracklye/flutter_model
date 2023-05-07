import 'package:example/app_settings.dart';
import 'package:example/notes/model_notes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/bloc/preferences/preferences_bloc.dart';
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
            onTap: () =>
                Navigator.of(context).pushReplacementNamed("/"),
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
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(ModelRouter.routeList<Notes>()),
          ),
          const Divider(),
        ])),
      ]));
    });
  }
}
