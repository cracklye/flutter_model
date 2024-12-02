// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_model/bloc/modeledit/model_edit_view2.dart';
// import 'package:flutter_model/flutter_model.dart';

// //import 'package:flutter/material.dart' as m;

// mixin class ModelDetail<T extends IModel> {
//   Widget buildBlocProvider(
//       BuildContext context, dynamic id, Function()? onDeleted) {
//     return BlocProvider<ModelEditViewBloc<T>>(
//         create: ((context) => ModelEditViewBloc<T>(
//             modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context))
//           ..add(ModelEditViewLoad<T>(id: id))),
//         child: buildBlocBuilder(context, onDeleted));
//   }

//   Widget buildBlocBuilder(BuildContext context, Function()? onDeleted) {
//     return BlocListener<ModelsEditViewBloc<T>, ModelsEditViewState<T>>(
//         listener: (context, state) => {
//               if (state is ModelsEditViewDelete<T>)
//                 {
//                   if (onDeleted != null) {onDeleted()}
//                 }
//             },
//         child: BlocBuilder<ModelsEditViewBloc<T>, ModelsEditViewState<T>>(
//           builder: (context, state) {
//             return buildBlocState(context, state);
//           },
//         ));
//   }

//   Widget buildBlocState(BuildContext context, ModelsEditViewState<T> state) {
//     if (state is ModelEditViewLoaded<T>) {
//       return buildBlocLoaded(context, state);
//     } else if (state is ModelsEditViewLoading<T>) {
//       return buildBlocLoading(context, state);
//     }
//     if (state is ModelsEditViewNotLoaded<T>) {
//       return buildBlocError(context, state);
//     }
//     return Text("Unknown state $state");
//   }

//   Widget buildBlocLoaded(
//       BuildContext context, ModelEditViewStateView<T> state) {
//     return const Text("Loaded");
//   }

//   Widget buildBlocLoading(
//       BuildContext context, ModelEditViewStateLoading<T> state) {
//     return const Text("Loading");
//   }

//   Widget buildBlocError(
//       BuildContext context, ModelsEditViewNotLoaded<T> state) {
//     return const Text("Error occurred");
//   }
// }
