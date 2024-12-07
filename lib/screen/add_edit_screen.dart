import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_events.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_view2.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:flutter_model/widgets/builder/models_editview_builder.dart';

class ModelScreenEdit<T extends IModel> extends StatelessWidget {
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

  List<IAction> getActions(BuildContext context, ModelEditViewState state) {
    return [
      IAction(
        icon: Icons.save,
        label: "Save",
        onSelected: (context, model) {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
          }
        },
      ),
      IAction(
          icon: Icons.cancel,
          label: "Cancel",
          onSelected: (context, state) => Navigator.of(context).pop())
    ];
  }

  Widget getPageTitle(BuildContext context, ModelEditViewState state) {
    if (state.isEditMode) {
      return const Text("Edit");
    }

    if (state.model != null) {
      return Text(state.model!.displayLabel);
    } else {
      return const Text("Edit");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModelEditViewBlocWidget<T>(
        id: id,
        provideBloc: true,
        buildListener: (context, state) {
          if (state.isSaved) {
            Navigator.pop(context);
          }
        },
        buildScaffold: (context, state, content) => Scaffold(
              body: content(context, state),
              appBar: AppBar(
                  centerTitle: false,
                  title: getPageTitle(context, state),
                  actions: getActions(context, state)
                      .map((e) => IconButton(
                          onPressed:()=> e.onSelected(context, state.model),
                          icon: Icon(e.icon),
                          tooltip: e.label))
                      .toList()),
            ),
        buildContent: (context, state) {
          if (state.isEmpty) {
            return const CircularProgressIndicator();
          }
          return Expanded(
              child: SingleChildScrollView(
                  child: buildForm(
                      context,
                      state as ModelEditViewStateLoaded<T>,
                      state.model,
                      formKey,
                      (values) => BlocProvider.of<ModelEditViewBloc<T>>(context)
                          .add(ModelEditViewEventSave<T>(values)),
                      initialProperties)));
        });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget buildForm(
    BuildContext context,
    ModelEditViewStateLoaded<T> state,
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
