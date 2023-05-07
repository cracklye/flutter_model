import 'package:example/routes/app_navigator.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text("Notess"),
        ),
        body: buildContent(context));

    //return buildBlocProvider(context);
  }

  Widget buildContent(BuildContext context) {
    return const Text("Hi");
  }
}
