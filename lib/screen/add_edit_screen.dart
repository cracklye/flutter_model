import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';

class ModelScreenEdit<T extends IModel> extends StatelessWidget
    with ModelEditBlocAddin<T> {
  final dynamic id;
  final dynamic parentId;
  final Function(BuildContext context)? onSaved;
  final Map<String, dynamic>? initialProperties;

  ModelScreenEdit({
    this.id,
    this.parentId,
    this.onSaved,
    this.initialProperties,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return buildEditBlocProvider(context,
        id: id, parentId: parentId, onSaved: onSaved);
  }

  @override
  Widget buildEditBlocContent(BuildContext context, ModelEditState<T> state) {
    return Scaffold(
      body: super.buildEditBlocContent(context, state),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Edit"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.cancel),
            tooltip: 'Cancel',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget buildEditBlocLoaded(
      BuildContext context, ModelEditStateLoaded<T> state) {
    return Expanded(child:SingleChildScrollView(
        child: buildForm(
            context,
            state,
            state.model,
            formKey,
            (values) => BlocProvider.of<ModelEditBloc<T>>(context)
                .add(ModelEditEventSave<T>(values)),
            initialProperties)));
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget buildForm(
    BuildContext context,
    ModelEditStateEdit<T> state,
    T? model,
    GlobalKey<FormState> formKey,
    void Function(Map<String, dynamic> onSave) onSave,
    Map<String, dynamic>? initalProperties,
  ) {
    return const Column(
      children: [
        Text("No form has been provided"),
      ],
    );
  }
}
