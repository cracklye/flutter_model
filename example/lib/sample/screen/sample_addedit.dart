// import 'package:flutter_bloc_modelframework/flutter_bloc_modelframework.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_geo_Sample/Sample/Sample_form.dart';
// import 'package:flutter_geo_Sample/model/Sample.dart';
import 'package:example/sample/model_sample.dart';
import 'package:example/sample/widget/sample_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/flutter_model.dart';

class SampleAddEditScreen extends ModelScreenEdit<Sample> {
  SampleAddEditScreen({super.key, super.id, super.parentId})
      : super(onSaved: (context) => Navigator.of(context).pop());
  @override
  Widget buildForm(
      BuildContext context,
      ModelEditViewStateLoaded<Sample> state,
      Sample? model,
      GlobalKey<FormState> formKey,
      void Function(Map<String, dynamic> onSave) onSave,
      Map<String, dynamic>? initalProperties) {
    return SampleForm(
      formKey: formKey,
      onSave: onSave,
      model: model,
    );
  }
}
