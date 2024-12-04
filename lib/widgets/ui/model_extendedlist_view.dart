
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_model/flutter_model.dart';
// import 'package:woue_components/woue_components.dart';


// @Deprecated("Replaced by the ModelList component")
// class ModelExtendedListView<T extends IModel> extends StatelessWidget {
//   const ModelExtendedListView({
//     super.key,
//     this.enabledListTypes = ListViewType.values,
//     this.orderBy,
//     this.filterBy,
//     this.tableColumns,
//     this.buildGridItem,
//     this.buildTreeItem,
//     this.buildListItem,
//     this.buildTableColumn,
//     this.onOrderByChange,
//     this.onFilterByChange,
//     this.onSearchChange,
//     this.onTap,
//     this.onDoubleTap,
//     this.onLongTap,
//     this.enableSearch = true,
//     this.listTypesIcons,
//     this.settingsKey,
//     this.settingsStorer,
//   });

//   final bool enableSearch;

//   final List<ListViewType> enabledListTypes;
//   final Map<ListViewType, IconData>? listTypesIcons;

//   final List<OrderByItem>? orderBy;
//   final List<FilterByItem<T>>? filterBy;
//   final List<TableColumn>? tableColumns;

//   final Function(OrderByItem?)? onOrderByChange;
//   final Function(FilterByItem<T>?)? onFilterByChange;
//   final Function(String?)? onSearchChange;
//   final Function(T)? onTap;
//   final Function(T)? onLongTap;
//   final Function(T)? onDoubleTap;

//   final Widget Function(BuildContext, T, Function()? onTap,
//       Function()? onDoubleTap, Function()? onLongPress)? buildListItem;
//   final Widget Function(BuildContext, T, Function()? onTap,
//       Function()? onDoubleTap, Function()? onLongPress)? buildGridItem;
//   final Widget Function(BuildContext, T)? buildTreeItem;
//   final Widget Function(BuildContext, T, TableColumn)? buildTableColumn;

//   final SettingsStorage? settingsStorer;
//   final String? settingsKey;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ModelsBloc<T>, ModelsState<T>>(
//       builder: ((context, state) {
//         bool isLoading = true;
//         List<T> items = [];
//         List<HierarchyEntry<T>>? hierarchy;

//         if (state is ModelsLoaded<T>) {
//           items = state.models;
//           hierarchy = state.hierarchy;
//           isLoading = false;
//         }
//         //TODO handle error

//         //if (state is ModelsLoaded<T>) {
//         return ExtendedListView<T>(
//           items: items,
//           hierarchy: hierarchy,

//           enabledListTypes: enabledListTypes,
//           buildGridItem: buildGridItem,
//           buildListItem: buildListItem,
//           buildTableColumn: buildTableColumn,
//           buildTreeItem: buildTreeItem,
//           enableSearch: enableSearch,
//           filterBy: filterBy,
//           orderBy: orderBy,
//           isLoading: isLoading,
//           // listTypesIcons: listTypesIcons,
//           onDoubleTap: onDoubleTap,
//           onLongTap: onLongTap,
//           onTap: onTap,

//           onOrderByChange: ((orderByChange) =>
//               BlocProvider.of<ModelsBloc<T>>(context).add(
//                   ModelsChangeOrderBy<T>(orderByChange != null
//                       ? orderByChange.getSortOrders()
//                       : null))),
//           onSearchChange: ((searchString) =>
//               BlocProvider.of<ModelsBloc<T>>(context)
//                   .add(ModelsChangeSearchText<T>(searchString))),

//           onFilterByChange: ((filter) =>
//               BlocProvider.of<ModelsBloc<T>>(context).add(
//                   ModelsChangeFilter<T>(
//                       filter != null ? filter.getFilters() : null))),

//           selected: state.selected,
//           settings: settingsStorer,
//           settingsKey: settingsKey,
//           tableColumns: tableColumns,

//           defaultSearchText: state.searchText,
//         );
//       }
//           // return Container();
//           //}
//           ),
//     );
//   }
// }
