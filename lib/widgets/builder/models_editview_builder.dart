import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_model/model/imodel.dart';
import 'package:flutter_model/persist/attachment_dao.dart';
import 'package:flutter_model/persist/model_dao.dart';
import 'package:flutter_model/screen/model_edit_view2.dart';


class ModelEditViewBuilder<T extends IModel> extends StatelessWidget {
  final Function(
    BuildContext context,
    T? model,
    bool isLoaded,
    bool isEdit,
    bool isView,
    bool isSaving,
    bool isChanged,
    ModelEditViewState<T> state,
    ModelEditViewBloc2<T> bloc,
  ) builder;

  const ModelEditViewBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModelEditViewBloc2<T>, ModelEditViewState<T>>(
        builder: (context, noteState) {
      return builder(
          context,
          noteState.model,
          (noteState is! ModelEditViewStateNotLoaded),
          (noteState is ModelEditViewStateEdit),
          (noteState is ModelEditViewStateView),
          (noteState is ModelEditViewStateSaving),
          (noteState is ModelEditViewStateChanged),
          noteState,
          BlocProvider.of<ModelEditViewBloc2<T>>(context));
    });
  }
}

class ModelEditViewProvider<T extends IModel> extends StatelessWidget {
  const ModelEditViewProvider(
      {super.key,
      required this.builder,
      required this.initEvent,
      this.initState});
  final Function() builder;
  final ModelEditViewEvent<T> initEvent;
  final ModelEditViewState<T>? initState;

  @override
  Widget build(BuildContext context) {
    AttachmentDAO? attachDao;
    try {
      attachDao = RepositoryProvider.of<AttachmentDAO>(context);
      // ignore: empty_catches
    } catch (e) {}

    return BlocProvider<ModelEditViewBloc2<T>>(
        create: ((context) => ModelEditViewBloc2<T>(
            RepositoryProvider.of<IModelAPI<T>>(context), attachDao)
          ..add(initEvent)),
        child: builder());
  }
}
