import 'package:example/dailyaction/model_dailyaction.dart';
import 'package:example/dailyaction/widget/dailyaction_display.dart';
import 'package:example/dailyaction/widget/dailyaction_form.dart';
import 'package:example/repos/dailyaction_repo_inmemory_slow.dart';
import 'package:example/routes/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/flutter_model.dart';

class DailyActionScreenListSingleSlow extends ModelScreenListScreen<DailyAction> {
  DailyActionScreenListSingleSlow({super.key})
      : super(
          drawer: const AppDrawer(),
          title: "DailyAction",
        );
        
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<IModelAPI<DailyAction>>(
        create: (context) => RepositoryDailyActionMemorySlow([
              DailyAction(
                  id: "1",
                  name: "Item 1",
                  description: "This is the first tiem"),
              DailyAction(
                  id: "2",
                  name: "Item 2",
                  description: "This is the first tiem"),
              DailyAction(
                  id: "3",
                  name: "Item 3",
                  description: "This is the first tiem"),
              DailyAction(
                  id: "4",
                  name: "Item 4",
                  description: "This is the first tiem"),
              DailyAction(
                  id: "5",
                  name: "Item 5",
                  description: "This is the first tiem"),
            ])
              ..init(),
        child: Builder(
          builder: (context) => super.build(context),
        ));
  }

  @override
  Widget buildDetailDisplayForModel(
      BuildContext context, ModelEditViewStateLoaded<DailyAction> state, DailyAction? model) {
    if (model == null) return const Text("Model is null");
    return DailyActionDisplay(model: model);
  }

  @override
  Widget buildForm(
    BuildContext context,
    ModelEditViewStateLoaded<DailyAction> state,
    DailyAction? model,
    GlobalKey<FormState> formKey,
    void Function(Map<String, dynamic>) onSave,
  ) {
    return DailyActionForm(
      model: model,
      formKey: formKey,
      onSave: onSave,
    );
  }
}
