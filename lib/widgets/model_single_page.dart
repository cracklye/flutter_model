import 'package:extended_list_view/extended_list_view.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';

class ModelSinglePage<T extends IModel> extends StatelessWidget
    with ModelListBlocAddin<T> {
  final double splitMinWidthEdit = 400;
  final double splitListWidth = 400;
  final dynamic parentId;
  final bool enableSplit;

  ModelSinglePage({Key? key, this.enableSplit = true, this.parentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildBlocProviderEdit(context);
  }

  Widget buildBlocProviderEdit(BuildContext context) {
    var attachDao;
    try {
      attachDao = RepositoryProvider.of<AttachmentDAO>(context);
    } catch (e) {}

    return BlocProvider(
        //'ModelEditViewBloc<Notes>
        create: ((context) => ModelEditViewBloc<T>(
            RepositoryProvider.of<IModelAPI<T>>(context),
            attachDao,
            ModelEditViewStateNotLoaded<T>())),
        child: buildListBlocProvider(context, parentId));
  }

  @override
  Widget buildListBlocContent(BuildContext context, ModelsListState<T> state) {
    return LayoutBuilder(builder: (context, size) {
      bool fullScreen = (splitMinWidthEdit == 0 ||
          size.maxWidth < (splitMinWidthEdit + splitListWidth));
      return buildListLayout(context, state, (!enableSplit) || fullScreen);
    });
  }

  Widget buildListLayout(
      BuildContext context, ModelsListState<T> state, bool fullScreen) {
    if (fullScreen) {
      return buildList(context, state, true);
    }

    const edge = EdgeInsets.fromLTRB(5, 0, 5, 0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: edge,
            child: SizedBox(
              width: splitListWidth,
              child: buildList(context, state, false),
            )),
        Expanded(
            child: Padding(
                padding: edge,
                child: SingleChildScrollView(
                    controller: ScrollController(),
                    //color: Colors.red,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: buildDetail(context, state)))))
      ],
    );
  }

  List<ListViewLayoutDefault<T>> getListDataProviders() {
    return [ListViewLayoutList(selectIcon: m.Icons.abc)];
  }

  Widget buildList(
      BuildContext context, ModelsListState<T> state, bool isFullScreen) {
    bool isLoading = true;
    List<T> items = [];
    if (state is ModelsListLoaded<T>) {
      items = state.models;
      isLoading = false;
    }

    return BlocBuilder<ModelEditViewBloc<T>, ModelEditViewState<T>>(
        builder: (context, editState) {
      return ExtendedListView<T>(
        listDataProviders: getListDataProviders(),
        selected:
            isFullScreen || editState.model == null ? [] : [editState.model!],
        isLoading: isLoading,
        items: items,
        onTap: isFullScreen
            ? ((model) => Navigator.of(context)
                .pushNamed(ModelRouter.routeDetail<T>(model.id)))
            : ((model) => BlocProvider.of<ModelEditViewBloc<T>>(context)
                .add(ModelEditViewEventSelect<T>(model, false))),
        onSearchChange: (p0) => BlocProvider.of<ModelsListBloc<T>>(context)
            .add(ModelsListChangeSearchText<T>(p0)),

//TODO order by and filter by
        // onOrderByChange: (orderByItem) {
        //     BlocProvider.of<ModelsListBloc<T>>(context)
        //     .add(ModelsListChangeOrderBy<T>(orderByItem as List<SortOrderBy<T>>));
        // },
      );
    });
  }

  Widget buildDetail(BuildContext context, ModelsListState<T> state) {
    return BlocBuilder<ModelEditViewBloc<T>, ModelEditViewState<T>>(
        builder:
            buildDetailState //(context, state) => Text("This is the buidler $state"),
        );
  }

  Widget buildDetailState(BuildContext context, ModelEditViewState<T> state) {
    if (state is ModelEditViewStateNotLoaded<T>) {
      return buildDetailNotSelected(context, state);
    } else if (state is ModelEditViewStateView<T>) {
      return buildDetailDisplay(context, state, state.model);
    } else if (state is ModelEditViewStateEdit<T>) {
      return buildDetailEdit(context, state, state.model);
    }
    return Text("Unhandled state: $state > ${state.model}");
  }

  Widget buildDetailNotSelected(
      BuildContext context, ModelEditViewStateNotLoaded<T> state) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Center(
          child: Text(""),
        )
      ],
    );
  }

  Widget buildDetailDisplay(
      BuildContext context, ModelEditViewStateView<T> state, T? model) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [buildDetailDisplayForModel(context, state, model)],
    );
  }

  Widget buildDetailDisplayForModel(
      BuildContext context, ModelEditViewStateView<T> state, T? model) {
    if (model == null) return const Text("Model is null");
    return Text(
        "Display page ${model.displayLabel} ID = ${model.id}  -  No Detail Page Provided");
  }

  Widget buildDetailEdit(
      BuildContext context, ModelEditViewStateEdit<T> state, T? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildForm(
            context,
            state,
            model,
            formKey,
            (values) => BlocProvider.of<ModelEditViewBloc<T>>(context)
                .add(ModelEditViewEventSave<T>(values, isEditMode: false)))
      ],
    );
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget buildForm(
    BuildContext context,
    ModelEditViewStateEdit<T> state,
    T? model,
    GlobalKey<FormState> formKey,
    void Function(Map<String, dynamic>) onSave,
  ) {
    return Column(
      children: const [
        Text("No form has been provided override the buildForm method"),
      ],
    );
  }
}

// class ModelSinglePage2<T extends IModel> extends StatelessWidget {
//   ModelSinglePage2({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return buildBlocProvider(context);
//   }

//   Widget buildBlocProvider(BuildContext context) {
//     return BlocProvider(
//       create: ((context) => ModelsListBloc(
//           modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context))
//         ..add(ModelsListLoad(
//             orderBy: [SortOrderByFieldName("_name", "name", true)]))),
//       child: buildBlocProviderEdit(context),
//     );
//   }

//   Widget buildBlocProviderEdit(BuildContext context) {
//     return BlocProvider(
//       create: ((context) => ModelEditViewBloc<T>(
//           RepositoryProvider.of<IModelAPI<T>>(context),
//           RepositoryProvider.of<AttachmentDAO>(context),
//           ModelEditViewStateNotLoaded<T>())),
//       child: buildBlocBuilder(context),
//     );
//   }

//   Widget buildBlocBuilder(BuildContext context) {
//     return BlocBuilder<ModelsListBloc<T>, ModelsListState<T>>(
//         builder: (context, state) {
//       return LayoutBuilder(builder: (context, size) {
//         logDebug("maxWidth $maxWidth , size.maxWidth =${size.maxWidth}");

//         if (maxWidth == 0 || size.maxWidth < maxWidth) {
//           return buildList(context, state);
//         }

//         return Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               width: 300,
//               child: buildList(context, state),
//             ),
//             Expanded(
//                 child: SingleChildScrollView(
//                     controller: ScrollController(),
//                     //color: Colors.red,
//                     child: buildDetail(context, state)))
//           ],
//         );
//       });
//     });
//   }

//   double maxWidth = 800;

//   /// Don't think this is called...
//   Widget buildStateLoaded(BuildContext context, ModelsListLoaded<T> state) {
//     return LayoutBuilder(builder: (context, size) {
//       logDebug("maxWidth $maxWidth , size.maxWidth =${size.maxWidth}");

//       if (maxWidth == 0 || size.maxWidth < maxWidth) {
//         return buildList(context, state);
//       }

//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 300,
//             child: buildList(context, state),
//           ),
//           Expanded(
//               child: SingleChildScrollView(
//                   controller: ScrollController(),
//                   //color: Colors.red,
//                   child: buildDetail(context, state)))
//         ],
//       );
//     });
//   }

//   // Widget buildList(BuildContext context, ModelsListState<T> state) {
//   //   return buildListView(context, state);
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       buildListHeader(context, state),
//   //       Expanded(flex: 1, child: buildListView(context, state)),
//   //     ],
//   //   );
//   // }

//   Widget buildListHeader(BuildContext context, ModelsListState<T> state) {
//     return SizedBox(
//       height: 30,
//       child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         ElevatedButton(
//             onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
//                 .add(CreateNewModel<T>()),
//             child: const Text("Create")),
//       ]),
//     );
//   }

//   Widget buildList(BuildContext context, ModelsListState<T> state) {
//     bool isLoading = true;
//     List<T> items = [];
//     if (state is ModelsListLoaded<T>) {
//       items = state.models;
//       isLoading = false;
//     }

//     return ExtendedListView<T>(
//       listDataProviders: [
//         ListViewLayoutList(selectIcon: m.Icons.abc)
//         //TODO need to add a list provider....
//       ],
//       isLoading: isLoading,
//       items: items,
//       onTap: ((model) => BlocProvider.of<ModelEditViewBloc<T>>(context)
//           .add(ModelEditViewEventSelect<T>(model, false))),
//       onSearchChange: (p0) => BlocProvider.of<ModelsListBloc<T>>(context)
//           .add(ModelsListChangeSearchText<T>(p0)),
//     );
//   }

//   Widget buildDetail(BuildContext context, ModelsListState<T> state) {
//     return Text("Hi");
//     return BlocBuilder<ModelEditViewBloc<T>, ModelEditViewState<T>>(
//       builder: buildDetailState,
//     );
//   }

//   Widget buildDetailState(BuildContext context, ModelEditViewState<T> state) {
//     if (state is ModelEditViewStateNotLoaded<T>) {
//       return buildDetailNotSelected(context, state);
//     } else if (state is ModelEditViewStateView<T>) {
//       return buildDetailDisplay(context, state, state.model);
//     } else if (state is ModelEditViewStateEdit<T>) {
//       return buildDetailEdit(context, state, state.model);
//     }
//     return Text("Unhandled state: $state > ${state.model}");
//   }

//   Widget buildDetailNotSelected(
//       BuildContext context, ModelEditViewStateNotLoaded<T> state) {
//     return Column(
//       // mainAxisSize: MainAxisSize.min,
//       // crossAxisAlignment: CrossAxisAlignment.stretch,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildActionBar(context, [
//           ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
//                   .add(ModelEditViewEventCreateNew<T>()),
//               child: const Text("Create")),
//         ]),
//         //Text(state.selected != null ? state.selected!.id ?? "" : "No Id"),
//         const Center(
//           child: Text(""),
//         )
//       ],
//     );
//   }

//   Widget buildDetailDisplay(
//       BuildContext context, ModelEditViewStateView<T> state, T? model) {
//     return Column(
//       // mainAxisSize: MainAxisSize.min,
//       // crossAxisAlignment: CrossAxisAlignment.stretch,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildActionBar(context, [
//           ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
//                   .add(ModelEditViewEventCreateNew<T>()),
//               child: const Text("Create")),
//           ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
//                   .add(ModelEditViewEventMode<T>(true)),
//               child: const Text("Edit")),
//           ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
//                   .add(ModelEditViewEventDelete<T>()),
//               child: const Text("Delete"))
//         ]),
//         //Text(state.selected != null ? state.selected!.id ?? "" : "No Id"),
//         buildDetailDisplayForModel(context, state, model)
//       ],
//     );
//   }

//   Widget buildDetailDisplayForModel(
//       BuildContext context, ModelEditViewStateView<T> state, T? model) {
//     if (model == null) return const Text("Model is null");
//     return Text(
//         "Display page ${model.displayLabel} ID = ${model.id}  -  No Detail Page Provided, override the buildDetailDisplayForModel() method");
//   }

//   Widget buildActionBar(BuildContext context, List<Widget> actions) {
//     return SizedBox(
//         height: 30,
//         child: Row(
//           children: actions,
//         ));
//   }

//   Widget buildDetailEdit(
//       BuildContext context, ModelEditViewStateEdit<T> state, T? model) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildActionBar(context, [
//           ElevatedButton(
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//                   formKey.currentState!.save();
//                 }
//               },
//               child: const Text("Save")),
//           ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
//                   .add(ModelEditViewEventMode<T>(false)),
//               child: const Text("Cancel"))
//         ]),
//         buildForm2(
//             context,
//             state,
//             model,
//             formKey,
//             (values) => BlocProvider.of<ModelEditViewBloc<T>>(context)
//                 .add(ModelEditViewEventSave<T>(values, isEditMode: false)))
//       ],
//     );
//   }

//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   Widget buildForm2(
//     BuildContext context,
//     ModelEditViewStateEdit<T> state,
//     T? model,
//     GlobalKey<FormState> formKey,
//     void Function(Map<String, dynamic>) onSave,
//   ) {
//     return Column(
//       children: const [
//         Text("No form has been provided"),
//       ],
//     );
//   }
// }

// class ModelSinglePageOld<T extends IModel> extends StatelessWidget {
//   ModelSinglePageOld({Key? key}) : super(key: key);

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
//       crossAxisAlignment: CrossAxisAlignment.start,
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
//         Expanded(flex: 1, child: buildListView(context, state)),
//       ],
//     );
//   }

//   Widget buildListHeader(BuildContext context, ModelsLoaded<T> state) {
//     return SizedBox(
//       height: 100,
//       child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
//         selected: state.models[index] == state.selected,
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
//       // mainAxisSize: MainAxisSize.min,
//       // crossAxisAlignment: CrossAxisAlignment.stretch,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildActionBar(context, [
//           ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
//                   .add(ModelSelect<T>(state.selected, ModelStateMode.edit)),
//               child: const Text("Edit")),
//           ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
//                   .add(DeleteModel<T>(state.selected!)),
//               child: const Text("Delete"))
//         ]),
//         //Text(state.selected != null ? state.selected!.id ?? "" : "No Id"),
//         buildDetailDisplayForModel(context, state, state.selected!)
//       ],
//     );
//   }

//   Widget buildDetailDisplayForModel(
//       BuildContext context, ModelsLoaded<T> state, T model) {
//     return Text(
//         "Display page ${state.selected!.displayLabel} ID = ${state.selected!.id}  -  No Detail Page Provided");
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
//       crossAxisAlignment: CrossAxisAlignment.start,
//       // mainAxisSize: MainAxisSize.min,
//       // crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         buildActionBar(context, [
//           // ElevatedButton(
//           //     onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
//           //         .add(UpdateSelected<T>()),
//           //     child: const Text("Save")),
//           ElevatedButton(
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//                   // BlocProvider.of<ModelsBloc<T>>(context)

//                   //     .add(UpdateModel<T>(state.selected!.id,  ));
//                   formKey.currentState!.save();
//                 }
//               },
//               child: const Text("Save")),

//           ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelsBloc<T>>(context)
//                   .add(SetEditMode<T>(false)),
//               child: const Text("Cancel"))
//         ]),
//         // Expanded(
//         //   child:
//         buildForm(
//             context,
//             state,
//             state.selected!,
//             formKey,
//             (values) => BlocProvider.of<ModelsBloc<T>>(context)
//                 .add(UpdateModel<T>(state.selected!.id, values)))

//         // (val) => BlocProvider.of<ModelsBloc<T>>(context)
//         //     .add(UpdateModelValue<T>(val))),
//         // )
//       ],
//     );
//   }

//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   Widget buildForm(
//     BuildContext context,
//     ModelsLoaded<T> state,
//     T model,
//     GlobalKey<FormState> formKey,
//     void Function(Map<String, dynamic>) onSave, //Function(T model) onUpdate
//   ) {
//     return Column(
//       children: const [
//         Text("No form has been provided"),
//       ],
//     );
//   }
// }

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
