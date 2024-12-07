import 'package:example/routes/app_navigator.dart';
import 'package:example/sample/model_sample.dart';
import 'package:example/sample/sample_repo_inmemory_slow.dart';
import 'package:example/sample/widget/sample_display.dart';
import 'package:example/sample/widget/sample_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/flutter_model.dart';

class SampleScreenListSingle extends ModelScreenListScreen<Sample> {
  SampleScreenListSingle({super.key})
      : super(
          drawer: const AppDrawer(),
          title: "Sample",
        );

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<IModelAPI<Sample>>(
        create: (context) => RepositorySampleMemorySlow([
              Sample(
                  id: "1",
                  name: "Item 1",
                  description: "This is the first tiem"),
              Sample(
                  id: "2",
                  name: "Item 2",
                  description: "This is the first tiem"),
              Sample(
                  id: "3",
                  name: "Item 3",
                  description: "This is the first tiem"),
              Sample(
                  id: "4",
                  name: "Item 4",
                  description: "This is the first tiem"),
              Sample(
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
  Widget buildDetailDisplayForModel(BuildContext context,
      ModelEditViewStateLoaded<Sample> state, Sample? model) {
    if (model == null) return const Text("Model is null");
    return SampleDisplay(model: model);
  }

  @override
  Widget buildForm(
    BuildContext context,
    ModelEditViewStateLoaded<Sample> state,
    Sample? model,
    GlobalKey<FormState> formKey,
    void Function(Map<String, dynamic>) onSave,
  ) {
    return SampleForm(
      model: model,
      formKey: formKey,
      onSave: onSave,
    );
  }
}
