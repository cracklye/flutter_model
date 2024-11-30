import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';

//import 'package:flutter/material.dart' as m;

mixin class ModelDetail<T extends IModel> {
  Widget buildBlocProvider(
      BuildContext context, dynamic id, Function()? onDeleted) {
    return BlocProvider<ModelsDetailBloc<T>>(
        create: ((context) => ModelsDetailBloc<T>(
            modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context))
          ..add(ModelsDetailLoad<T>(id: id))),
        child: buildBlocBuilder(context, onDeleted));
  }

  Widget buildBlocBuilder(BuildContext context, Function()? onDeleted) {
    return BlocListener<ModelsDetailBloc<T>, ModelsDetailState<T>>(
        listener: (context, state) => {
              if (state is ModelsDetailDelete<T>)
                {
                  if (onDeleted != null) {onDeleted()}
                }
            },
        child: BlocBuilder<ModelsDetailBloc<T>, ModelsDetailState<T>>(
          builder: (context, state) {
            return buildBlocState(context, state);
          },
        ));
  }

  Widget buildBlocState(BuildContext context, ModelsDetailState<T> state) {
    if (state is ModelsDetailLoaded<T>) {
      return buildBlocLoaded(context, state);
    } else if (state is ModelsDetailLoading<T>) {
      return buildBlocLoading(context, state);
    }
    if (state is ModelsDetailNotLoaded<T>) {
      return buildBlocError(context, state);
    }
    return Text("Unknown state $state");
  }

  Widget buildBlocLoaded(BuildContext context, ModelsDetailLoaded<T> state) {
    return const Text("Loaded");
  }

  Widget buildBlocLoading(BuildContext context, ModelsDetailLoading<T> state) {
    return const Text("Loading");
  }

  Widget buildBlocError(BuildContext context, ModelsDetailNotLoaded<T> state) {
    return const Text("Error occurred");
  }
}
