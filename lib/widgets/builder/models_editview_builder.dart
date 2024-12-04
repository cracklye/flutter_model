import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_events.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_view2.dart';
import 'package:flutter_model/flutter_model.dart';

class ModelEditViewBlocWidget<T extends IModel> extends StatelessWidget {
  final bool provideBloc;
  final dynamic id;

  final Widget Function(BuildContext context, ModelEditViewState<T> state,
          Function(BuildContext context, ModelEditViewState<T> state))?
      buildScaffold;

  final Widget Function(BuildContext context, ModelEditViewState<T> state)?
      buildContent;

  final void Function(BuildContext context, ModelEditViewState<T> state)?
      buildListener;

  const ModelEditViewBlocWidget(
      {super.key,
      this.provideBloc = false,
      this.id,
      this.buildContent,
      this.buildListener,
      this.buildScaffold});

  @override
  Widget build(BuildContext context) {
    if (provideBloc) {
      return _buildProvider(context);
    } else {
      return _buildConsumerOrListener(context);
    }
  }

  Widget _buildConsumerOrListener(context) {
    if (buildListener != null) {
      return _buildListener(context);
    } else {
      return _buildConsumer(context);
    }
  }

  Widget _buildProvider(BuildContext context) {
    AttachmentDAO? attachDao;
    try {
      attachDao = RepositoryProvider.of<AttachmentDAO>(context);
      // ignore: empty_catches
    } catch (e) {}

    return BlocProvider<ModelEditViewBloc<T>>(
        create: ((context) => ModelEditViewBloc<T>(
            RepositoryProvider.of<IModelAPI<T>>(context), attachDao)
          ..add(id != null
              ? ModelEditViewEventSelect<T>(id, false)
              : ModelEditViewEventClear<T>())),
        child: _buildConsumerOrListener(context));
  }

  Widget _buildListener(BuildContext context) {
    return BlocListener<ModelEditViewBloc<T>, ModelEditViewState<T>>(
      listener: buildListener!,
      child: _buildConsumer(context),
    );
  }

  Widget _buildConsumer(
    BuildContext context,
  ) {
    return BlocBuilder<ModelEditViewBloc<T>, ModelEditViewState<T>>(
        builder: (context, state) {
      if (buildScaffold != null) {
        return buildScaffold!(
            context, state, (buildContent ?? _buildDefaultContent));
      } else {
        return (buildContent ?? _buildDefaultContent)(context, state);
      }
    });
  }

  Widget _buildDefaultContent(
      BuildContext context, ModelEditViewState<T> state) {
    return const Text("No Default content has been provided");
  }
}




// class ModelEditViewBuilder<T extends IModel> extends StatelessWidget {
//   final Function(
//     BuildContext context,
//     T? model,
//     bool isLoaded,
//     bool isEdit,
//     bool isView,
//     bool isSaving,
//     bool isChanged,
//     ModelEditViewState<T> state,
//     ModelEditViewBloc<T> bloc,
//   ) builder;

//   const ModelEditViewBuilder({super.key, required this.builder});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ModelEditViewBloc<T>, ModelEditViewState<T>>(
//         builder: (context, noteState) {
//       return builder(
//           context,
//           noteState.model,
//           (noteState is! ModelEditViewStateNotLoaded),
//           (noteState is ModelEditViewStateEdit),
//           (noteState is ModelEditViewStateView),
//           (noteState is ModelEditViewStateSaving),
//           (noteState is ModelEditViewStateChanged),
//           noteState,
//           BlocProvider.of<ModelEditViewBloc<T>>(context));
//     });
//   }
// }

// class ModelEditViewProvider<T extends IModel> extends StatelessWidget {
//   const ModelEditViewProvider(
//       {super.key,
//       required this.builder,
//       required this.initEvent,
//       this.initState});
//   final Function() builder;
//   final ModelEditViewEvent<T> initEvent;
//   final ModelEditViewState<T>? initState;

//   @override
//   Widget build(BuildContext context) {
//     AttachmentDAO? attachDao;
//     try {
//       attachDao = RepositoryProvider.of<AttachmentDAO>(context);
//       // ignore: empty_catches
//     } catch (e) {}

//     return BlocProvider<ModelEditViewBloc<T>>(
//         create: ((context) => ModelEditViewBloc<T>(
//             RepositoryProvider.of<IModelAPI<T>>(context), attachDao)
//           ..add(initEvent)),
//         child: builder());
//   }
// }
