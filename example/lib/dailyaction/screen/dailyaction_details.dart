// import 'package:flutter/material.dart';

import 'package:example/dailyaction/model_dailyaction.dart';
import 'package:example/dailyaction/widget/dailyaction_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/flutter_model.dart';

class DailyActionDetailScreen extends ModelScreenDetail<DailyAction> {
  DailyActionDetailScreen({
    required super.id,
    super.key,
  }) : super(onDeleted: (context) => Navigator.of(context).pop());

  @override
  Widget buildDetailBlocContent(
      BuildContext context, ModelEditViewState<DailyAction> state) {
    if (state.isEmpty) {
      return const CircularProgressIndicator();
    }
    
    return SingleChildScrollView(
        child: DailyActionDisplay(model: state.model!));
  }

  // @override
  // Widget buildDetailBlocLoaded(
  //     BuildContext context, ModelEditViewStateLoaded<DailyAction> state) {
  //   return SingleChildScrollView(child: DailyActionDisplay(model: state.model!));
  // }
}
