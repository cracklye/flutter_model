// import 'package:flutter_bloc_modelframework/flutter_bloc_modelframework.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_geo_DailyAction/DailyAction/DailyAction_form.dart';
// import 'package:flutter_geo_DailyAction/model/DailyAction.dart';
import 'package:example/dailyaction/model_dailyaction.dart';
import 'package:example/dailyaction/widget/dailyaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/flutter_model.dart';

class DailyActionAddEditScreen extends ModelScreenEdit<DailyAction> {
  DailyActionAddEditScreen({super.key, super.id, super.parentId})
      : super(onSaved: (context) => Navigator.of(context).pop());
  @override
  Widget buildForm(
      BuildContext context,
      ModelEditViewStateLoaded<DailyAction> state,
      DailyAction? model,
      GlobalKey<FormState> formKey,
      void Function(Map<String, dynamic> onSave) onSave,
      Map<String, dynamic>? initalProperties) {
    return DailyActionForm(
      formKey: formKey,
      onSave: onSave,
      model: model,
    );
  }
}
