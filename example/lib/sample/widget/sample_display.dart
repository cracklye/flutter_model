import 'package:example/sample/model_sample.dart';
import 'package:flutter/material.dart';

import 'package:woue_components/woue_components.dart';

class SampleDisplay extends StatelessWidget {
  const SampleDisplay({super.key, required this.model});
  final Sample model;

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
            buildContent: Text(model.description )),
      ],
    );
  }
}
