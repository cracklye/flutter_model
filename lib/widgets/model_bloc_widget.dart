

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';

abstract class ModelBlocWidget<T extends IModel> extends StatelessWidget {
  const ModelBlocWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModelsBloc<T>, ModelsState<T>>(
        builder: (context, state) {
      if (state is ModelsLoaded<T>) {
        return buildStateLoaded(context, state as ModelsLoaded<T>);
      } else if (state is ModelsLoading<T>) {
        return buildStateLoading(context, state);
      } else {
        return buildStateNotLoaded(context, state as ModelsNotLoaded<T>);
      }
    });
  }

  Widget buildStateLoaded(BuildContext context, ModelsLoaded<T> state);

  Widget buildStateLoading(BuildContext context, ModelsLoading<T> state) {
    return const Text("loading....");
  }

  Widget buildStateNotLoaded(BuildContext context, ModelsNotLoaded<T> state) {
    return const Text("Not loaded data");
  }
}
