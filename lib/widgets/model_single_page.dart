part of flutter_model;

class ModelSinglePage<T extends IModel> extends StatelessWidget {
  const ModelSinglePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModelsBloc<T>, ModelsState<T>>(
        builder: (context, state) {
      if (state is ModelsLoaded<T>) {
        return buildStateLoaded(context, state);
      } else if (state is ModelsLoading<T>) {
        return buildStateLoading(context, state);
      } else {
        return buildStateNotLoaded(context, state as ModelsNotLoaded<T>);
      }
    });
  }

  Widget buildStateLoaded(BuildContext context, ModelsLoaded<T> state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 300,
          child: buildList(context, state),
        ),
        Expanded(
            child: SingleChildScrollView(
                controller: ScrollController(),
                //color: Colors.red,
                child: buildDetail(context, state)))
      ],
    );
  }

  Widget buildStateLoading(BuildContext context, ModelsLoading<T> state) {
    return const Text("State is Loading");
  }

  Widget buildStateNotLoaded(BuildContext context, ModelsNotLoaded<T> state) {
    return const Text("State is not loaded");
  }

  Widget buildList(BuildContext context, ModelsLoaded<T> state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildListHeader(context, state),
        Expanded(flex: 1, child: buildListView(context, state)),
      ],
    );
  }

  Widget buildListHeader(BuildContext context, ModelsLoaded<T> state) {
    return SizedBox(
      height: 100,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ElevatedButton(
            onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
                .add(CreateNewModel<T>()),
            child: const Text("Create")),
      ]),
    );
  }

  Widget buildListView(BuildContext context, ModelsLoaded<T> state) {
    return ListView.builder(
      itemBuilder: (ctx, index) => ListTile(
        title: Text(state.models[index].displayLabel),
        onTap: () => BlocProvider.of<ModelsBloc<T>>(context)
            .add(ModelSelect<T>(state.models[index])),
      ),
      itemCount: state.models.length,
    );
  }

  Widget buildDetail(BuildContext context, ModelsLoaded<T> state) {
    if (state.selected == null) {
      return const Text("No item selected");
    } else if (state.mode == ModelStateMode.edit) {
      return buildDetailEdit(context, state);
    } else {
      return buildDetailDisplay(context, state);
    }
    //return Text("detail will appear here ${state.selected}\n\n${state.parameters}");
  }

  Widget buildDetailDisplay(BuildContext context, ModelsLoaded<T> state) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildActionBar(context, [
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
                  .add(ModelSelect<T>(state.selected, ModelStateMode.edit)),
              child: const Text("Edit")),
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
                  .add(DeleteModel<T>(state.selected!)),
              child: const Text("Delete"))
        ]),
        //Text(state.selected != null ? state.selected!.id ?? "" : "No Id"),
        buildDetailDisplayForModel(context, state, state.selected!)
      ],
    );
  }

  Widget buildDetailDisplayForModel(
      BuildContext context, ModelsLoaded<T> state, T model) {
    return Text(
        "Display page ${state.selected!.displayLabel} ID = ${state.selected!.id}  -  No Detail Page Provided");
  }

  Widget buildActionBar(BuildContext context, List<Widget> actions) {
    // return IntrinsicWidth(
    //   child: Container(
    //     color: Colors.blue,
    //     child: Text("Hi"),
    //   ),
    // );
    return SizedBox(
        // width: double.infinity,
        height: 30,
        //  color: Colors.blue[100],
        child: Row(
          children: actions,
        ));
  }

  Widget buildDetailEdit(BuildContext context, ModelsLoaded<T> state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildActionBar(context, [
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
                  .add(UpdateSelected<T>()),
              child: const Text("Save")),
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
                  .add(ModelSelect<T>(null)),
              child: const Text("Cancel"))
        ]),
        // Expanded(
        //   child:
        buildForm(
            context,
            state,
            state.selected!,
            (val) => BlocProvider.of<ModelsBloc<T>>(context)
                .add(UpdateModelValue<T>(val))),
        // )
      ],
    );
  }

  Widget buildForm(BuildContext context, ModelsLoaded<T> state, T model,
      Function(T model) onUpdate) {
    return Column(
      children: const [
        Text("No form has been provided"),
      ],
    );
  }
}

// class ModelSinglePage<T extends IModel> extends StatelessWidget {
//   const ModelSinglePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ModelsBloc<T>, ModelsState<T>>(
//         builder: (context, state) {
//       if (state is ModelsLoaded<T>) {
//         return buildStateLoaded(context, state);
//       } else if (state is ModelsLoading<T>) {
//         return buildStateLoading(context, state);
//       } else {
//         return buildStateNotLoaded(context, state as ModelsNotLoaded<T>);
//       }
//     });
//   }

//   Widget buildStateLoaded(BuildContext context, ModelsLoaded<T> state) {
//     return Row(
//       children: [
//         SizedBox(
//           width: 300,
//           child: buildList(context, state),
//         ),
//         Expanded(
//             child: SingleChildScrollView(
//                 controller: ScrollController(),
//                 //color: Colors.red,
//                 child: buildDetail(context, state)))
//       ],
//     );
//   }

//   Widget buildStateLoading(BuildContext context, ModelsLoading<T> state) {
//     return const Text("State is Loading");
//   }

//   Widget buildStateNotLoaded(BuildContext context, ModelsNotLoaded<T> state) {
//     return const Text("State is not loaded");
//   }

//   Widget buildList(BuildContext context, ModelsLoaded<T> state) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildListHeader(context, state),
//         Expanded(child: buildListView(context, state), flex: 1),
//       ],
//     );
//   }

//   Widget buildListHeader(BuildContext context, ModelsLoaded<T> state) {
//     return SizedBox(
//       height: 100,
//       child: Row(children: [
//         ElevatedButton(
//             onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
//                 .add(CreateNewModel<T>()),
//             child: const Text("Create")),
//       ]),
//     );
//   }

//   Widget buildListView(BuildContext context, ModelsLoaded<T> state) {
//     return ListView.builder(
//       itemBuilder: (ctx, index) => ListTile(
//         title: Text(state.models[index].displayLabel),
//         onTap: () => BlocProvider.of<ModelsBloc<T>>(context)
//             .add(ModelSelect<T>(state.models[index])),
//       ),
//       itemCount: state.models.length,
//     );
//   }

//   Widget buildDetail(BuildContext context, ModelsLoaded<T> state) {
//     if (state.selected == null) {
//       return const Text("No item selected");
//     } else if (state.mode == ModelStateMode.edit) {
//       return buildDetailEdit(context, state);
//     } else {
//       return buildDetailDisplay(context, state);
//     }
//     //return Text("detail will appear here ${state.selected}\n\n${state.parameters}");
//   }

//   Widget buildDetailDisplay(BuildContext context, ModelsLoaded<T> state) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       // mainAxisSize: MainAxisSize.min,
//       // crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         buildActionBar(context, [
          
//           ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
//                   .add(ModelSelect<T>(state.selected!, ModelStateMode.edit)),
//               child: const Text("Edit")),
//           ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
//                   .add(DeleteModel<T>(state.selected!)),
//               child: const Text("Delete"))
//         ]),
//         Text(state.selected != null ? state.selected!.id ?? "" : "No Id"),
//         buildDetailDisplayForModel(context, state, state.selected!)
//       ],
//     );
//   }

//   Widget buildDetailDisplayForModel(
//       BuildContext context, ModelsLoaded<T> state, T model) {
//     return Text(
//         "Display page ${state.selected!.displayLabel} ID = ${state.selected!.id}");
//   }

//   Widget buildActionBar(BuildContext context, List<Widget> actions) {
//     // return IntrinsicWidth(
//     //   child: Container(
//     //     color: Colors.blue,
//     //     child: Text("Hi"),
//     //   ),
//     // );
//     return SizedBox(
//         // width: double.infinity,
//         height: 30,
//         //  color: Colors.blue[100],
//         child: Row(
//           children: actions,
//         ));
//   }

//   Widget buildDetailEdit(BuildContext context, ModelsLoaded<T> state) {
//     return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           // mainAxisSize: MainAxisSize.min,
//           // crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             buildActionBar(context, [
//               ElevatedButton(
//                   onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
//                       .add(UpdateSelected<T>()),
//                   child: const Text("Save")),
//               ElevatedButton(
//                   onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
//                       .add(ModelSelect<T>(null)),
//                   child: const Text("Cancel"))
//             ]),
//             Expanded(
//               child: buildForm(
//                   context,
//                   state,
//                   state.selected!,
//                   (val) => BlocProvider.of<ModelsBloc<T>>(context)
//                       .add(UpdateModelValue<T>(val))),
//             )
//           ],
//         );
//   }

//   Widget buildForm(BuildContext context, ModelsLoaded<T> state, T model,
//       Function(T model) onUpdate) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("No form has been provided"),
//       ],
//     );
//   }
// }
