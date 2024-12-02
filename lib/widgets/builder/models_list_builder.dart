// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_model/flutter_model.dart';

// class ModelListBuilder<T extends IModel> extends StatelessWidget {
//   final Function(
//     BuildContext context,
//     List<T> models,
//     List<T>? selected,
//     bool isLoading,
//     bool isLoaded,
//     ModelsState<T> state,
//     ModelsBloc<T> bloc,
//   ) builder;

//   const ModelListBuilder({super.key, required this.builder});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ModelsBloc<T>, ModelsState<T>>(
//         builder: (context, noteState) {
//       bool isLoading = noteState is ModelsLoading<T>;
//       bool isLoaded = false;
//       List<T> models = [];
//       List<T>? selected;
//       if (noteState is ModelsLoaded<T>) {
//         models = noteState.models;
//         selected = noteState.selected;
//         isLoaded = true;
//       }
//       return builder(context, models, selected, isLoading, isLoaded, noteState,
//           BlocProvider.of<ModelsBloc<T>>(context));
//     });
//   }
// }

// class ModelListProvider<T extends IModel> extends StatelessWidget {
//   const ModelListProvider(
//       {super.key,
//       required this.builder,
//       required this.initEvent,
//       this.initState});
//   final Function() builder;
//   final ModelsEvent<T> initEvent;
//   final ModelsState<T>? initState;

//   @override
//   Widget build(BuildContext context2) {
//     return BlocProvider<ModelsBloc<T>>(
//         create: ((context) => ModelsBloc<T>(
//             initialState: initState,
//             modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context))
//           ..add(initEvent)),
//         child: builder());
//   }
// }
