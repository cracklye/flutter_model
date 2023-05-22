import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:loggy/loggy.dart';

import 'package:flutter/material.dart';

abstract class ModelScreenList<T extends IModel> extends ModelSinglePage<T>
    with UiLoggy {
  final Widget? drawer;
  final String? title;
  final String? parentId;
  ModelScreenList({super.key, super.enableSplit = true, this.drawer, this.title, this.parentId});

  @override
  Widget buildListLayout(
      BuildContext context, ModelsListState<T> state, bool fullScreen) {
    return BlocBuilder<ModelEditViewBloc<T>, ModelEditViewState<T>>(
        builder: (context, editState) {
      List<Widget> rtn = [];
      if (fullScreen) {
        rtn.add(ElevatedButton(
            onPressed: () => Navigator.of(context)
                .pushNamed(ModelRouter.routeAdd<T>(parentId)),
            child: const Text("Create")));
      } else {
        if (editState is ModelEditViewStateView<T>) {
          rtn.add(ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventCreateNew<T>()),
              child: const Text("Create")));

          rtn.add(ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventMode<T>(true)),
              child: const Text("Edit")));
          rtn.add(ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventDelete<T>()),
              child: const Text("Delete")));
        } else if (editState is ModelEditViewStateNotLoaded<T>) {
          rtn.add(ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventCreateNew<T>()),
              child: const Text("Create")));
        } else if (editState is ModelEditViewStateEdit<T>) {
          rtn.add(ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                }
              },
              child: const Text("Save")));
          rtn.add(ElevatedButton(
              onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
                  .add(ModelEditViewEventMode<T>(false)),
              child: const Text("Cancel")));
        }
      }

      return Scaffold(
          drawer: drawer,
          appBar: AppBar(
            actions: rtn,
            title: Text(title ?? ""),
          ),
          body: super.buildListLayout(context, state, fullScreen));
    });
  }
}


// enum SearchPosition { ActionBar, AboveList }

// class ModelScreenList<T extends IModel> extends StatefulWidget with UiLoggy {
//   final Function(BuildContext context, T? selected)? onSelectDisplay;
//   final Function(BuildContext context, T? selected)? onSelectEdit;
//   final Function(BuildContext context, T? selected)? onSelectDelete;
//   final Function(
//     BuildContext context,
//   )? onSelectAdd;
//   final Widget Function(BuildContext context, T model, Function(T) onTap)?
//       buildListItem;

//   final Widget? drawer;
//   final bool enableAdd;
//   final SearchPosition searchPosition;
//   final bool enableSearchButton;
//   final dynamic parentId;

//   ModelScreenList(
//       {Key? key,
//       this.parentId,
//       this.onSelectDisplay,
//       this.onSelectEdit,
//       this.onSelectAdd,
//       this.onSelectDelete,
//       this.buildListItem,
//       this.drawer,
//       this.enableAdd = true,
//       this.searchPosition = SearchPosition.ActionBar,
//       this.enableSearchButton = true,
//       List<OrderByListOption>? orderBy})
//       : super(
//           key: key,
//         ) {
//     //print("ScreenList init orderBy: ${this.orderBy} ");
//   }

//   @override
//   State<ModelScreenList<T>> createState() => _ModelScreenListState<T>();
// }

// class _ModelScreenListState<T extends IModel> extends State<ModelScreenList<T>>
//     with ModelListBlocAddin<T>, UiLoggy {
//   bool searchEnabled = false;

//   @override
//   initState() {
//     super.initState();
//     searchEnabled = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return buildListBlocProvider(context, widget.parentId);
//   }

//   @override
//   Widget buildListBlocContent(BuildContext context, ModelsListState<T> state) {
//     return BlocBuilder<ModelEditViewBloc<T>, ModelEditViewState<T>>(
//         builder: (context, editState) {
//       List<Widget> rtn = [];
//       rtn.addAll(buildActions(context));
//       if (editState is ModelEditViewStateView) {
//         rtn.add(ElevatedButton(
//             onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
//                 .add(ModelEditViewEventCreateNew<T>()),
//             child: const Text("Create")));
//         rtn.add(ElevatedButton(
//             onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
//                 .add(ModelEditViewEventMode<T>(true)),
//             child: const Text("Edit")));
//         rtn.add(ElevatedButton(
//             onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
//                 .add(ModelEditViewEventDelete<T>()),
//             child: const Text("Delete")));
//       }
      


//       return m.Scaffold(
//         appBar: m.AppBar(
//           title: buildAppBarTitle(context),
//           actions: rtn ,//buildActions(context),
//         ),
//         drawer: widget.drawer,
//         body: super.buildListBlocContent(context, state),
//         floatingActionButton: buildFloatingActionButton(context),
//         bottomNavigationBar: buildBottomNavigation(context),
//       );
//     });
//   }

//   @override
//   Widget buildListBlocLoaded(BuildContext context, ModelsListLoaded<T> state) {
//     if (widget.searchPosition == SearchPosition.ActionBar) {
//       print("modelScreenList.buildBody - actionBar");
//       return buildList(
//           context,
//           state,
//           () => print("Dismissed"),
//           (model) => widget.onSelectDisplay!(
//               context, model)); // onTap: onTap, onDismissed: onDismissed);
//     } else {
//       print("modelScreenList.buildBody - column");
//       return Column(children: [
//         buildSearch(context),
//         Expanded(
//             child: buildList(
//                 context,
//                 state,
//                 null,
//                 widget
//                     .onSelectDisplay) //, onTap: onTap, onDismissed: onDismissed))
//             )
//       ]);
//     }
//   }

//   String getTitle() {
//     return "List";
//   }

//   Widget buildAppBarTitle(context) {
//     if (widget.searchPosition == SearchPosition.ActionBar) {
//       return Column(
//         children: [
//           this.searchEnabled ? Container() : Text(getTitle()),
//           buildSearch(context)
//         ],
//       );
//     } else {
//       return Text(getTitle());
//     }
//   }

//   Widget? buildBottomNavigation(BuildContext context) {
//     return null; //Container();
//   }

//   Widget? buildSort(BuildContext context) {
//     return null;
//   }

//   Widget buildSearch(BuildContext context) {
//     if (this.searchEnabled) {
//       //return FilterText<T>();
//       return Container();
//     } else {
//       return Container();
//     }
//   }

//   Widget buildList(
//       BuildContext context, ModelsListLoaded<T> state, onDismissed, onTap) {
//     return ListView.builder(
//       itemBuilder: (context, index) => widget.buildListItem != null
//           ? widget.buildListItem!(context, state.models[index], onTap)
//           : buildListItem(state.models[index], index, onDismissed, onTap),
//       itemCount: state.models.length,
//     );
//   }

//   Widget buildListItem(T model, int index, onDismissed, onTap) {
//     return Text(model.displayLabel);
//   }

//   Widget buildFloatingActionButton(BuildContext context) {
//     if (widget.enableAdd) {
//       return m.FloatingActionButton(
//         tooltip: 'Add Model',
//         child: Icon(m.Icons.edit),
//         onPressed: () {
//           if (widget.onSelectAdd != null) {
//             widget.onSelectAdd!(context);
//           }
//         },
//       );
//     } else {
//       return Container();
//     }
//   }

//   // FilteredModelsBloc<T> getFilteredModelsBloc(BuildContext context) {
//   //   return FilteredModelsBloc<T>(
//   //       modelsBloc: BlocProvider.of<ModelsBloc<T>>(context));
//   // }
//   List<Widget> buildActions(BuildContext context) {
//     // return [buildSearch(context)];
//     List<Widget> rtn = [];
//     if (widget.enableSearchButton) {
//       rtn.add(IconButton(
//         icon: Icon(searchEnabled ? m.Icons.cancel : m.Icons.search),
//         onPressed: () {
//           if (searchEnabled) {
//             //Send a clear search option
//             // VisibilityFilterText<T> filter = VisibilityFilterText<T>("");

//             // BlocProvider.of<FilteredModelsBloc<T>>(context)
//             //     .add(UpdateFilter<T>(filter));
//           }
//           setState(() {
//             searchEnabled = !searchEnabled;
//           });
//         },
//       ));
//     }
//     // print("BuildActions ${widget.orderBy} ");
//     // if (widget.orderBy != null && widget.orderBy!.length > 1) {
//     //   //Create the search button
//     //   rtn.add(m.PopupMenuButton<OrderByListOption>(
//     //     icon: Icon(m.Icons.sort),
//     //     onSelected: (OrderByListOption selected) =>
//     //         BlocProvider.of<ModelsBloc<T>>(context)
//     //             .add(OrderByModel<T>(selected.orderBy)),
//     //     //  BlocProvider.of<ModelsBloc<Location>>(context)
//     //     //             .add(LoadModels<Location>());

//     //     itemBuilder: (BuildContext context) {
//     //       return widget.orderBy!.map((OrderByListOption choice) {
//     //         return m.PopupMenuItem<OrderByListOption>(
//     //           value: choice,
//     //           child: Text(choice.label),
//     //         );
//     //       }).toList();
//     //     },
//     //   ));
//     // }
//     //rtn.add(value);
//     //  rtn.add(IconButton(
//     //   icon: Icon(Icons.add),
//     //   onPressed: () {
//     //      this.doAdd(context);
//     //   },
//     // ));
//     return rtn;
//   }
// }
