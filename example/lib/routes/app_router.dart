import 'package:example/notes/model_notes.dart';
import 'package:example/notes/screen/note_addedit.dart';
import 'package:example/notes/screen/note_details.dart';
import 'package:example/notes/screen/note_list_single.dart';
import 'package:example/sample/screen/sample_addedit.dart';
import 'package:example/sample/screen/sample_details.dart';
import 'package:example/sample/screen/sample_list_single.dart';
import 'package:example/screens/home.dart';
import 'package:example/screens/test_view.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:flutter_model/flutter_model.dart';

class AppRouter {
  static FluroRouter router = FluroRouter();

  static final Handler _home = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const HomeScreen());
  static final Handler _testViewScreen = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const TestViewScreen(title: "Test"));

  static final Handler _noteList = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          NotesScreenListSingle());

  static final Handler _noteDetail = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          NoteDetailScreen(id: params["id"]?[0]));

  static final Handler _noteEdit = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          NotesAddEditScreen(id: params["id"]?[0], parentId: params["id"]?[0]));

  static setupRouter() {
    ModelRouter.routeSetupCRUD<Notes>(router,
        list: _noteList, detail: _noteDetail, edit: _noteEdit, add: _noteEdit);

    ModelRouter.routeSetupCRUD<Sample>(router,
        list: Handler(
            handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
                SampleScreenListSingle()),
        detail: Handler(
            handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
                SampleDetailScreen(id: params["id"]?[0])),
        edit: _noteEdit,
        add: Handler(
            handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
                SampleAddEditScreen(
                    id: params["id"]?[0], parentId: params["id"]?[0])));

    router.define(
      "/",
      handler: _home,
    );

    router.define(
      "/testslowlist",
      handler: Handler(
          handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
              NotesScreenListSingle()),
    );

    router.define(
      "/testListScreen",
      handler: _testViewScreen,
    );
  }
}
