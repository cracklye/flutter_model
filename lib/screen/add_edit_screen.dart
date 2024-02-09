import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';

class ModelScreenEdit<T extends IModel> extends StatelessWidget
    with ModelEditBlocAddin<T> {
  final dynamic id;
  final dynamic parentId;
  final Function(BuildContext context)? onSaved;

  ModelScreenEdit({
    this.id,
    this.parentId,
    this.onSaved,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildEditBlocProvider(context,
        id: id, parentId: parentId, onSaved: onSaved);
  }

  @override
  Widget buildEditBlocContent(BuildContext context, ModelEditState<T> state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
        actions: [
          ElevatedButton(
            child: const Icon((Icons.save)),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
              }
            },
          ),
        ],
      ),
      body: super.buildEditBlocContent(context, state),
    );
  }

  @override
  Widget buildEditBlocLoaded(
      BuildContext context, ModelEditStateLoaded<T> state) {
    return buildForm(
        context,
        state,
        state.model,
        formKey,
        (values) => BlocProvider.of<ModelEditBloc<T>>(context)
            .add(ModelEditEventSave<T>(values)));
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget buildForm(
    BuildContext context,
    ModelEditStateEdit<T> state,
    T? model,
    GlobalKey<FormState> formKey,
    void Function(Map<String, dynamic>) onSave,
  ) {
    return Column(
      children: const [
        Text("No form has been provided"),
      ],
    );
  }
}
