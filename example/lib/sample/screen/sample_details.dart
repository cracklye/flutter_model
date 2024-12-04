// import 'package:flutter/material.dart';

import 'package:example/sample/model_sample.dart';

import 'package:example/sample/widget/sample_display.dart';

import 'package:flutter/material.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/flutter_model.dart';

class SampleDetailScreen extends ModelScreenDetail<Sample> {
  SampleDetailScreen({
    required super.id,
    super.key,
  }) : super(onDeleted: (context) => Navigator.of(context).pop());

  @override
  Widget buildDetailBlocLoaded(
      BuildContext context, ModelEditViewStateLoaded<Sample> state) {
    return SingleChildScrollView(child: SampleDisplay(model: state.model!));
  }
}

