// import 'package:extended_list_view/extended_list_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_model/flutter_model.dart';
// import 'package:flutter_model/widgets/builder/models_editview_builder.dart';
// import 'package:notd/framework/bloc/model_edit_view2.dart' as m;
// import 'package:notd/framework/builders/models_editview_builder.dart';
// import 'package:notd/framework/builders/models_list_builder.dart';

// class SinglePageLayout<T extends IModel> extends StatelessWidget {
//   final bool enableSplit;
//   bool get isFullScreen => !enableSplit;

//   const SinglePageLayout(
//       {super.key, this.enableSplit = true, this.insets = 10});

//   @override
//   Widget build(BuildContext context) {
//     return buildPage(context);
//   }

//   final double insets;
//   Widget buildPage(BuildContext context) {
//     if (enableSplit) {
//       return ModelEditViewProvider<T>(
//           initEvent: const m.ModelEditViewEventClear(),
//           builder: () => Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: Padding(
//                         padding: EdgeInsets.all(insets),
//                         child: buildListView(context)),
//                   ),
//                   VerticalDivider(
//                     width: 1,
//                     color: Colors.grey[300],
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Padding(
//                         padding: EdgeInsets.all(insets),
//                         child: buildEditView(context)),
//                   ),
//                 ],
//               ));
//     } else {
//       return Padding(
//           padding: EdgeInsets.all(insets), child: buildListView(context));
//     }
//   }

//   Widget buildFilter(BuildContext context) {
//     return Container();
//   }

//   List<ListViewOrderByItem> getOrderBy() {
//     return [];
//   }

//   Widget buildListView(BuildContext context) {
//     return ModelListBuilder<T>(
//       builder: (context, models, selected, isLoading, isLoaded, state, bloc) {
//         return ExtendedListView<T>(
//             buildToolbarSub: buildFilter,
//             listDataProviders: getListDataProviders(),
//             selected: isFullScreen || selected == null ? [] : selected,
//             isLoading: isLoading,
//             items: models,
//             defaultSearchText: state.searchText,
//             orderBy: getOrderBy(),
//             selectedOrderBy: state.orderBy,
//             onOrderByChange: (p) => BlocProvider.of<ModelsListBloc<T>>(context)
//                 .add(ModelsListChangeOrderBy<T>(p?.value)),
//             onDoubleTap: (model) => Navigator.of(context)
//                 .pushNamed(ModelRouter.routeDetail<T>(model.id)),
//             onTap: isFullScreen
//                 ? ((model) => Navigator.of(context)
//                     .pushNamed(ModelRouter.routeDetail<T>(model.id)))
//                 : ((model) {
//                     BlocProvider.of<m.ModelEditViewBloc2<T>>(context)
//                         .add(m.ModelEditViewEventSelect<T>(model.id, false));
//                     BlocProvider.of<ModelsListBloc<T>>(context)
//                         .add(ModelListSelect<T>(model));
//                   }),
//             onSearchChange: (p0) => BlocProvider.of<ModelsListBloc<T>>(context)
//                 .add(ModelsListChangeSearchText<T>(p0)));
//       },
//     );
//   }

//   Widget buildEditView(BuildContext context) {
//     return ModelEditViewBuilder<T>(
//         builder: (context, model, isLoaded, isEdit, isView, isSaving, isChanged,
//                 state, bloc) =>
//             buildDetailDisplayForModel(context, model, isLoaded, isEdit, isView,
//                 isSaving, isChanged, state, bloc));
//     // Text("edit view");
//   }

//   Widget buildDetailDisplayForModel(
//     BuildContext context,
//     T? model,
//     bool isLoaded,
//     bool isEdit,
//     bool isView,
//     bool isSaving,
//     bool isChanged,
//     m.ModelEditViewState<T> state,
//     m.ModelEditViewBloc2<T> bloc,
//   ) {
//     return Text(
//         "Edit view \n model:$model \n isLoaded: $isLoaded \n isEdit: $isEdit \n isView: $isView \n isSaving $isSaving \n isChangedL$isChanged");
//   }

//   List<ListViewLayoutDefault<T>> getListDataProviders() {
//     return [ListViewLayoutList(selectIcon: Icons.abc)];
//   }
// }
