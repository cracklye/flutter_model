part of flutter_model;

class ModelSinglePage<T extends IModel> extends StatelessWidget {
  ModelSinglePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildBlocProvider(context);
  }

  Widget buildBlocProvider(BuildContext context) {
    return BlocProvider(
      create: ((context) => ModelsListBloc(
          modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context))
        ..add(ModelsListLoad(
            orderBy: [SortOrderByFieldName("_name", "name", true)]))),
      child: buildBlocProviderEdit(context),
    );
  }

  Widget buildBlocProviderEdit(BuildContext context) {
    return BlocProvider(
      create: ((context) => ModelEditBloc<T>(
          RepositoryProvider.of<IModelAPI<T>>(context),
          RepositoryProvider.of<AttachmentDAO>(context),
          ModelEditStateNotLoaded<T>())),
      child: buildBlocBuilder(context),
    );
  }

  Widget buildBlocBuilder(BuildContext context) {
    return BlocBuilder<ModelsListBloc<T>, ModelsListState<T>>(
        builder: (context, state) {
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
    });
  }

  Widget buildStateLoaded(BuildContext context, ModelsListLoaded<T> state) {
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

  // Widget buildList(BuildContext context, ModelsListState<T> state) {
  //   return buildListView(context, state);
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       buildListHeader(context, state),
  //       Expanded(flex: 1, child: buildListView(context, state)),
  //     ],
  //   );
  // }

  Widget buildListHeader(BuildContext context, ModelsListState<T> state) {
    return SizedBox(
      height: 30,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ElevatedButton(
            onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
                .add(CreateNewModel<T>()),
            child: const Text("Create")),
      ]),
    );
  }

  Widget buildList(BuildContext context, ModelsListState<T> state) {
    return ModelExtendedListView<T>(
      
      enabledListTypes:const  [ListViewType.list],
      onTap: ((model) => BlocProvider.of<ModelEditBloc<T>>(context)
          .add(ModelEditEventSelect<T>(model, false))),
    );
  }

  Widget buildDetail(BuildContext context, ModelsListState<T> state) {
    return BlocBuilder<ModelEditBloc<T>, ModelEditState<T>>(
      builder: buildDetailState,
    );
  }

  Widget buildDetailState(BuildContext context, ModelEditState<T> state) {
    if (state is ModelEditStateNotLoaded<T>) {
      return buildDetailNotSelected(context, state) ;
    } else if (state is ModelEditStateView<T>) {
      return buildDetailDisplay(context, state, state.model);
    } else if (state is ModelEditStateEdit<T>) {
      return buildDetailEdit(context, state, state.model);
    }
    return Text("Unhandled state: $state > ${state.model}");
  }


  Widget buildDetailNotSelected(
      BuildContext context, ModelEditStateNotLoaded<T> state) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildActionBar(context, [
           ElevatedButton(
            onPressed: () => BlocProvider.of<ModelEditBloc<T>>(context)
                .add(ModelEditEventCreateNew<T>()),
            child: const Text("Create")),
       ]),
        //Text(state.selected != null ? state.selected!.id ?? "" : "No Id"),
       const  Center(child: Text(""),)
      ],
    );
  }



  Widget buildDetailDisplay(
      BuildContext context, ModelEditStateView<T> state, T? model) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildActionBar(context, [
           ElevatedButton(
            onPressed: () => BlocProvider.of<ModelEditBloc<T>>(context)
                .add(ModelEditEventCreateNew<T>()),
            child: const Text("Create")),

          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditBloc<T>>(context)
                  .add(ModelEditEventMode<T>(true)),
              child: const Text("Edit")),

          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditBloc<T>>(context)
                  .add(ModelEditEventDelete<T>()),
              child: const Text("Delete"))
        ]),
        //Text(state.selected != null ? state.selected!.id ?? "" : "No Id"),
        buildDetailDisplayForModel2(context, state, model)
      ],
    );
  }

  Widget buildDetailDisplayForModel2(
      BuildContext context, ModelEditStateView<T> state, T? model) {
    if (model == null) return const Text("Model is null");
    return Text(
        "Display page ${model.displayLabel} ID = ${model.id}  -  No Detail Page Provided");
  }

  Widget buildActionBar(BuildContext context, List<Widget> actions) {
    return SizedBox(
        height: 30,
        child: Row(
          children: actions,
        ));
  }

  Widget buildDetailEdit(
      BuildContext context, ModelEditStateEdit<T> state, T? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildActionBar(context, [
          ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                }
              },
              child: const Text("Save")),
          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditBloc<T>>(context)
                  .add(ModelEditEventMode<T>(false)),
              child: const Text("Cancel"))
        ]),
        buildForm2(
            context,
            state,
            model,
            formKey,
            (values) => BlocProvider.of<ModelEditBloc<T>>(context)
                .add(ModelEditEventSave<T>(values ,isEditMode : false)))
      ],
    );
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget buildForm2(
    BuildContext context,
    ModelEditStateEdit<T> state,
    T? model,
    GlobalKey<FormState> formKey,
    void Function(Map<String, dynamic>) onSave, 
  ) {
    return Column(
      children: const [
        Text("No form has been provided"),
      ],
    );
  }
}

class ModelSinglePageOld<T extends IModel> extends StatelessWidget {
  ModelSinglePageOld({Key? key}) : super(key: key);

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
        selected: state.models[index] == state.selected,
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
          // ElevatedButton(
          //     onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
          //         .add(UpdateSelected<T>()),
          //     child: const Text("Save")),
          ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // BlocProvider.of<ModelsBloc<T>>(context)

                  //     .add(UpdateModel<T>(state.selected!.id,  ));
                  formKey.currentState!.save();
                }
              },
              child: const Text("Save")),

          ElevatedButton(
              onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
                  .add(SetEditMode<T>(false)),
              child: const Text("Cancel"))
        ]),
        // Expanded(
        //   child:
        buildForm(
            context,
            state,
            state.selected!,
            formKey,
            (values) => BlocProvider.of<ModelsBloc<T>>(context)
                .add(UpdateModel<T>(state.selected!.id, values)))

        // (val) => BlocProvider.of<ModelsBloc<T>>(context)
        //     .add(UpdateModelValue<T>(val))),
        // )
      ],
    );
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget buildForm(
    BuildContext context,
    ModelsLoaded<T> state,
    T model,
    GlobalKey<FormState> formKey,
    void Function(Map<String, dynamic>) onSave, //Function(T model) onUpdate
  ) {
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
