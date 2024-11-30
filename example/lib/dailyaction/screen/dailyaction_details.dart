// import 'package:flutter/material.dart';

import 'package:example/dailyaction/model_dailyaction.dart';
import 'package:example/dailyaction/widget/dailyaction_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_model/flutter_model.dart';

class NoteDetailScreen extends ModelScreenDetail<DailyAction> {
  NoteDetailScreen({
    required super.id,
    super.key,
  }) : super(onDeleted: (context) => Navigator.of(context).pop());

  @override
  Widget buildDetailBlocLoaded(
      BuildContext context, ModelsDetailLoaded<DailyAction> state) {
    return SingleChildScrollView(child: DailyActionDisplay(model: state.model));
  }
}
