import 'package:example/dailyaction/model_dailyaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_model/flutter_model.dart';

class DailyActionDisplay extends StatelessWidget {
  const DailyActionDisplay({super.key, required this.model});
  final DailyAction model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelWidget(
            buildLabel: const Text("Label"),
            buildContent: Text(model.displayLabel)),
        LabelWidget(
            buildLabel: const Text("Created Date"),
            buildContent: Text(model.createdDate.toString())),
        LabelWidget(
            buildLabel: const Text("Description"),
            buildContent: Text(model.description)),
      ],
    );
  }
}
