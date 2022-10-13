part of flutter_model;

class ModelExtendedListView<T extends IModel> extends StatelessWidget {
  ModelExtendedListView({
    super.key,
    this.enabledListTypes = ListViewType.values,
    this.orderBy,
    this.filterBy,
    this.tableColumns,
    this.buildGridItem,
    this.buildTreeItem,
    this.buildListItem,
    this.buildTableColumn,
    this.onOrderByChange,
    this.onFilterByChange,
    this.onSearchChange,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
    this.enableSearch = true,
    this.listTypesIcons,
    this.settingsKey,
    this.settingsStorer,
  });

  final bool enableSearch;

  final List<ListViewType> enabledListTypes;
  final Map<ListViewType, IconData>? listTypesIcons;

  final List<OrderByItem>? orderBy;
  final List<FilterByItem<T>>? filterBy;
  final List<TableColumn>? tableColumns;

  final Function(OrderByItem?)? onOrderByChange;
  final Function(FilterByItem<T>?)? onFilterByChange;
  final Function(String?)? onSearchChange;
  final Function(T)? onTap;
  final Function(T)? onLongTap;
  final Function(T)? onDoubleTap;

  final Widget Function(BuildContext, T)? buildListItem;
  final Widget Function(BuildContext, T)? buildGridItem;
  final Widget Function(BuildContext, T)? buildTreeItem;
  final Widget Function(BuildContext, T, TableColumn)? buildTableColumn;

  final SettingsStorage? settingsStorer;
  final String? settingsKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModelsListBloc<T>, ModelsListState<T>>(
      builder: ((context, state) {
        if (state is ModelsListLoaded<T>) {
          return ExtendedListView<T>(
            items: state.models,
            hierarchy: state.hierarchy,
            enabledListTypes: enabledListTypes,
            buildGridItem: buildGridItem,
            buildListItem: buildListItem,
            buildTableColumn: buildTableColumn,
            buildTreeItem: buildTreeItem,
            enableSearch: enableSearch,
            filterBy: filterBy,
            orderBy: orderBy,

            // listTypesIcons: listTypesIcons,
            onDoubleTap: onDoubleTap,
            onLongTap: onLongTap,
            onTap: onTap,

            onOrderByChange: ((orderByChange) =>
                BlocProvider.of<ModelsListBloc<T>>(context).add(
                    ModelsListChangeOrderBy<T>(orderByChange != null
                        ? orderByChange!.getSortOrders()
                        : null))),
            onSearchChange: ((searchString) =>
                BlocProvider.of<ModelsListBloc<T>>(context)
                    .add(ModelsListChangeSearchText<T>(searchString))),
            onFilterByChange: ((filter) =>
                BlocProvider.of<ModelsListBloc<T>>(context).add(
                    ModelsListChangeFilter<T>(
                        filter != null ? filter.getFilters() : null))),

            selected: state.selected,
            settings: settingsStorer,
            settingsKey: settingsKey,
            tableColumns: tableColumns,

            defaultSearchText : state.searchText, 
          );
        }
        return Container();
      }),
    );
  }
}