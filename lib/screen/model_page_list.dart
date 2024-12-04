// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_model/bloc/modeledit/model_edit_events.dart';
// import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
// import 'package:flutter_model/bloc/modeledit/model_edit_view2.dart';
// import 'package:flutter_model/flutter_model.dart';
// import 'package:loggy/loggy.dart';

// abstract class ModelPageList<T extends IModel> extends ModelSinglePage<T>
//     with UiLoggy {
//   ModelPageList(
//       {super.key,
//       super.enableSplit = true,
//       super.parentId,
//       splitMinWidthEdit = 600});

//   Widget buildListLayout2(
//       BuildContext context, ModelsState<T> state, editState, bool fullScreen) {
//     if (fullScreen) {
//       return buildList(context, state, editState, true);
//     }

//     const edge = EdgeInsets.fromLTRB(5, 0, 5, 0);

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//             padding: edge,
//             child: SizedBox(
//               width: splitListWidth,
//               child: buildList(context, state, editState, false),
//             )),
//         //buildDetail(context, state)

//         Expanded(
//             child: Padding(
//                 padding: edge,
//                 child: Padding(
//                     padding: const EdgeInsets.only(top: 20),
//                     child: buildDetail(context, state, editState))))
//       ],
//     );
//   }

//   @override
//   Widget buildListLayout(
//       BuildContext context, ModelsState<T> state, editState, bool fullScreen) {
//     return BlocBuilder<ModelEditViewBloc<T>, ModelEditViewState<T>>(
//         builder: (context, editState) {
//       var fab = getFloatingActionButton(context);

//       List<Widget> rtn = [];
//       if (fullScreen && fab == null) {
//         rtn.add(ElevatedButton(
//             onPressed: () => Navigator.of(context)
//                 .pushNamed(ModelRouter.routeAdd<T>(parentId)),
//             child: const Text("Create")));
//       } else {
//         if (!editState.isEditMode) {
//           rtn.add(ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
//                   .add(ModelEditViewEventCreateNew<T>()),
//               child: const Text("Create")));

//           rtn.add(ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
//                   .add(ModelEditViewEventMode<T>(true)),
//               child: const Text("Edit")));
//           rtn.add(ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
//                   .add(ModelEditViewEventDelete<T>(editState.model!.id)),
//               child: const Text("Delete")));
//         } else if (editState is ModelEditViewStateNotLoaded<T> && fab == null) {
//           rtn.add(ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
//                   .add(ModelEditViewEventCreateNew<T>()),
//               child: const Text("Create")));
//         } else if (editState.isEditMode) {
//           rtn.add(ElevatedButton(
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//                   formKey.currentState!.save();
//                 }
//               },
//               child: const Text("Save")));
//           rtn.add(ElevatedButton(
//               onPressed: () => BlocProvider.of<ModelEditViewBloc<T>>(context)
//                   .add(ModelEditViewEventMode<T>(false)),
//               child: const Text("Cancel")));
//         }
//       }

//       return buildListLayout2(context, state, editState, fullScreen);
//     });
//   }

//   FloatingActionButtonLocation? getfloatingActionButtonLocation() {
//     return null;
//   }

//   Widget? getFloatingActionButton(BuildContext context) {
//     return null;
//   }
// }