import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';

class ModelListBlocWidget<T extends IModel> extends StatelessWidget {
  final bool provideBloc;
  final dynamic parentId;

  final Widget Function(BuildContext context, ModelsState<T> state,
      Function(BuildContext context, ModelsState<T> state))? buildScaffold;

  final Widget Function(BuildContext context, ModelsState<T> state)?
      buildContent;

  const ModelListBlocWidget(
      {super.key,
      this.provideBloc = false,
      this.parentId,
      this.buildContent,
      this.buildScaffold});

  @override
  Widget build(BuildContext context) {
    if (provideBloc) {
      return _buildProvider(context);
    } else {
      return _buildConsumer(context);
    }
  }

  Widget _buildProvider(BuildContext context) {
    // return BlocProvider(
    //   create: (context) => ModelEditViewBloc<T>(dao, attachmentDao),
    //   child: _buildConsumer(context),
    // );
    // AttachmentDAO? attachDao;
    // try {
    //   attachDao = RepositoryProvider.of<AttachmentDAO>(context);
    //   // ignore: empty_catches
    // } catch (e) {}

    return BlocProvider<ModelsBloc<T>>(
        create: ((context) => ModelsBloc<T>(
                initialState: ModelsNotLoaded(),
                attachmentDao: RepositoryProvider.of<AttachmentDAO>(context),
                modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context))
            ..add(ModelsLoad(parentId: parentId,))
            ),
        child: _buildConsumer(context));
  }

  Widget _buildConsumer(
    BuildContext context,
  ) {
    return BlocBuilder<ModelsBloc<T>, ModelsState<T>>(
        builder: (context, state) {
      if (buildScaffold != null) {
        return buildScaffold!(
            context, state, (buildContent ?? _buildDefaultContent));
      } else {
        return (buildContent ?? _buildDefaultContent)(context, state);
      }
    });
  }

  Widget _buildDefaultContent(BuildContext context, ModelsState<T> state) {
    return const Text("No Default content has been provided");
  }
}
