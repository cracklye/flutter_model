import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';

//import 'package:flutter/material.dart' as m;

abstract class ModelDetailBlocAddin<T extends IModel> {
  Widget buildDetailBlocProvider(BuildContext context, dynamic id,
      Function(BuildContext context)? onDeleted) {
    return BlocProvider<ModelsDetailBloc<T>>(
        create: ((context) => ModelsDetailBloc<T>(
            modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context))
          ..add(ModelsDetailLoad<T>(id: id))),
        child: buildDetailBlocBuilder(context, onDeleted));
  }

  Widget buildDetailBlocBuilder(
      BuildContext context, Function(BuildContext context)? onDeleted) {
    return BlocListener<ModelsDetailBloc<T>, ModelsDetailState<T>>(
        listener: (context, state) => {
              if (state is ModelDeleted<T>)
                {
                  if (onDeleted != null) {onDeleted(context)}
                }
            },
        child: BlocBuilder<ModelsDetailBloc<T>, ModelsDetailState<T>>(
          builder: (context, state) {
            return buildDetailBlocContent(context, state);
          },
        ));
  }

  Widget buildDetailBlocContent(
      BuildContext context, ModelsDetailState<T> state) {
    if (state is ModelsDetailLoaded<T>) {
      return buildDetailBlocLoaded(context, state);
    } else if (state is ModelsDetailLoading<T>) {
      return buildDetailBlocLoading(context, state);
    }
    if (state is ModelsDetailNotLoaded<T>) {
      return buildDetailBlocNotLoaded(context, state);
    }
    if (state is ModelsDetailError<T>) {
      return buildDetailBlocError(context, state);
    }
    return Text("Unknown state $state");
  }

  Widget buildDetailBlocLoaded(
      BuildContext context, ModelsDetailLoaded<T> state) {
    return const Text("Loaded");
  }

  Widget buildDetailBlocLoading(
      BuildContext context, ModelsDetailLoading<T> state) {
    return const Text("Loading");
  }

  Widget buildDetailBlocNotLoaded(
      BuildContext context, ModelsDetailNotLoaded<T> state) {
    return const Text("Not loaded");
  }

  Widget buildDetailBlocError(
      BuildContext context, ModelsDetailError<T> state) {
    return Text("Error occurred ${state.errorMessage}");
  }

  bool isDetailLoaded(ModelsDetailState<T> state) {
    if (state is ModelsDetailLoaded<T>) {
      return true;
    }
    return false;
  }

  bool isDetailLoading(ModelsDetailState<T> state) {
    if (state is ModelsDetailLoading<T>) {
      return true;
    }
    return false;
  }

  void doDelete(BuildContext context, T model) {
    BlocProvider.of<ModelsDetailBloc<T>>(context)
        .add(ModelsDetailDelete<T>(model.id));
  }
}
