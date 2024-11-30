import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';

mixin ModelInfoMixin<T extends IModel> {
  Widget buildBlocProvider(BuildContext context, dynamic id) {
    return BlocProvider<ModelsDetailBloc<T>>(
      create: ((context) => ModelsDetailBloc<T>(
          modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context))
        ..add(ModelsDetailLoad(id: id))),
      child: buildBlocBuilder(),
    );
  }

  Widget buildBlocBuilder() {
    return BlocBuilder<ModelsDetailBloc<T>, ModelsDetailState<T>>(
        builder: ((context, state) => buildBlocContent(context, state)));
  }

  Widget buildBlocContent(BuildContext context, ModelsDetailState<T> state) {
    if (state is ModelsDetailLoaded<T>) {
      return buildBlocLoaded(context, state);
    } else if (state is ModelsDetailLoading<T>) {
      return buildBlocLoading(context, state);
    } else if (state is ModelsDetailNotLoaded<T>) {
      return buildBlocNotLoaded(context, state);
    } else {
      return Text("Unknown state $state");
    }
  }

  Widget buildBlocLoaded(BuildContext context, ModelsDetailLoaded<T> state) {
    return const Text("Loaded");
  }

  Widget buildBlocLoading(BuildContext context, ModelsDetailLoading<T> state) {
    return Text("Loading ${state.id}");
  }

  Widget buildBlocNotLoaded(
      BuildContext context, ModelsDetailNotLoaded<T> state) {
    return const Text("Not Loaded");
  }
}
