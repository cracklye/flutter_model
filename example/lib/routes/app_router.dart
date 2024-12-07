import 'package:example/dailyaction/model_dailyaction.dart';
import 'package:example/dailyaction/screen/dailyaction_addedit.dart';
import 'package:example/dailyaction/screen/dailyaction_details.dart';
import 'package:example/dailyaction/screen/dailyaction_list_screen.dart';
import 'package:example/notes/model_notes.dart';
import 'package:example/notes/screen/note_addedit.dart';
import 'package:example/notes/screen/note_details.dart';
import 'package:example/notes/screen/note_list_single_screen.dart';
import 'package:example/notes/screen/note_list_single_slow.dart';
import 'package:example/sample/screen/sample_addedit.dart';
import 'package:example/sample/screen/sample_details.dart';
import 'package:example/sample/screen/sample_list_screen.dart';
import 'package:example/screens/home.dart';
import 'package:example/screens/test_view.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
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
          NotesScreenListScreen());

  static final Handler _noteDetail = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          NoteDetailScreen(id: params["id"]?[0]));

  static final Handler _noteEdit = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          NotesAddEditScreen(id: params["id"]?[0], parentId: params["id"]?[0]));

  static final Handler _actionList = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          DailyActionListScreen());

  static final Handler _actionDetail = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          DailyActionDetailScreen(id: params["id"]?[0]));

  static final Handler _actionEdit = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          DailyActionAddEditScreen(
              id: params["id"]?[0], parentId: params["id"]?[0]));

  static final Handler _noteListDialog = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          NotesScreenListScreen(
            enableSplit: false,
            editActionStyle: ActionStyle.dialog,
            displayActionStyle: ActionStyle.dialog,
            createActionStyle: ActionStyle.dialog,
          ));

  static final Handler _noteListPaneDialog = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          NotesScreenListScreen(
            editActionStyle: ActionStyle.dialog,
            displayActionStyle: ActionStyle.dialog,
            createActionStyle: ActionStyle.dialog,
          ));
  static final Handler _noteListUri = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          NotesScreenListScreen(
            enableSplit: false,
            editActionStyle: ActionStyle.uri,
            displayActionStyle: ActionStyle.uri,
            createActionStyle: ActionStyle.uri,
          ));

  static final Handler _noteListPaneUri = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          NotesScreenListScreen(
            editActionStyle: ActionStyle.uri,
            displayActionStyle: ActionStyle.uri,
            createActionStyle: ActionStyle.uri,
          ));

  static setupRouter() {
    ModelRouter.routeSetupCRUD<Notes>(router,
        list: _noteList, detail: _noteDetail, edit: _noteEdit, add: _noteEdit);

    ModelRouter.routeSetupCRUD<DailyAction>(router,
        list: _actionList,
        detail: _actionDetail,
        edit: _actionEdit,
        add: _actionEdit);

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
              NotesScreenListSingleSlow()),
    );

    router.define(
      "/_noteListDialog",
      handler: _noteListDialog,
    );

    router.define(
      "/_noteListPaneDialog",
      handler: _noteListPaneDialog,
    );

    router.define(
      "/_noteListUri",
      handler: _noteListUri,
    );

    router.define(
      "/_noteListPaneUri",
      handler: _noteListPaneUri,
    );

    router.define(
      "/testListScreen",
      handler: _testViewScreen,
    );
  }
}
