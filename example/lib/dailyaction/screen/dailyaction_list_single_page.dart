import 'package:example/dailyaction/model_dailyaction.dart';
import 'package:example/dailyaction/widget/dailyaction_display.dart';
import 'package:example/dailyaction/widget/dailyaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/flutter_model.dart';

class DailyActionScreenListPage extends ModelScreenListPage<DailyAction> {
  DailyActionScreenListPage({super.key})
      : super(
          title: "DailyAction",
        );

  @override
  Widget buildDetailDisplayForModel(BuildContext context,
      ModelEditViewStateLoaded<DailyAction> state, DailyAction? model) {
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