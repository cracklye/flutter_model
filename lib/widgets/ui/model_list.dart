
part of flutter_model;


class ModelList<T extends IModel> extends StatelessWidget {
  const ModelList({
    super.key,
    this.parentId,
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
    this.onReorder,
    this.enableSearch = true,
    this.listTypesIcons,
    this.settingsKey,
    this.settings,
    this.enableSelect = true,

  });
  final String? parentId;
  final bool enableSelect;
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

  final Widget Function(BuildContext, T,Function()? onTap, Function()? onDoubleTap, Function()? onLongTap)? buildListItem;
  final Widget Function(BuildContext, T, Function()? onTap, Function()? onDoubleTap, Function()? onLongTap, )? buildGridItem;
  final Widget Function(BuildContext, T)? buildTreeItem;
  final Widget Function(BuildContext, T, TableColumn)? buildTableColumn;
  final void Function(int previousPosition, int newPosition, T item, T? before,
      T? after, T? parent)? onReorder;


  final SettingsStorage? settings;
  final String? settingsKey;
  @override
  Widget build(BuildContext context) => buildBlocProvider(context);

  Widget buildBlocProvider(BuildContext context) {
    return BlocProvider<ModelsListBloc<T>>(
        create: ((context) => ModelsListBloc<T>(
            modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context))
          ..add(ModelsListLoad<T>(
              parentId: parentId,
              //filters: filterBy,
              orderBy: (orderBy != null && orderBy!.isNotEmpty)
                  ? orderBy![0].getSortOrders()
                  : null))),
        child: buildBlocBuilder(context));
  }

  Widget buildBlocBuilder(BuildContext context) {
    return BlocBuilder<ModelsListBloc<T>, ModelsListState<T>>(
      builder: (context, state) {
        return buildBlocLoaded(context, state);

        // if (state is ModelsListLoaded<T>) {
        //   return buildBlocLoaded(context, state);
        // } else if (state is ModelsListLoading<T>) {
        //   return buildBlocLoading(context, state);
        // }
        // if (state is ModelsListNotLoaded<T>) {
        //   return buildBlocError(context, state);
        // }
        // return Text("Unknown state");
      },
    );
  }

  Widget buildBlocLoaded(BuildContext context, ModelsListState<T> state) {
    List<T> items = [];
    List<T>? selected = [];
    List<HierarchyEntry<T>>? hierarchy;
    bool isLoading = true;
    //TODO handle error
    if (state is ModelsListLoaded<T>) {
      selected = state.selected;
      items = state.models;
      hierarchy = state.hierarchy;
      isLoading = false;
    }

    return ExtendedListView<T>(
      orderBy: orderBy,
      settingsKey: settingsKey,
      selected: selected,
      tableColumns: tableColumns,
      onTap: (model) {
        
        if (enableSelect) {
          BlocProvider.of<ModelsListBloc<T>>(context)
              .add(ModelListSelect<T>((model)));
        }
        
        if (onTap != null) {
        
          onTap!(model);
        }
      },
      onReorder: onReorder,
      isLoading: isLoading,
      items: items,
      hierarchy: hierarchy,
      onDoubleTap: onDoubleTap,
      buildGridItem: buildGridItem,
      buildListItem: buildListItem,
      buildTableColumn: buildTableColumn,
      buildTreeItem: buildTreeItem,
      enableSearch: enableSearch,
      enabledListTypes: enabledListTypes,
      filterBy: filterBy,
      key: key,
      listTypesIcons: const {
        ListViewType.grid: m.Icons.grid_3x3,
        ListViewType.list: m.Icons.list,
        ListViewType.tree: m.Icons.thermostat_rounded,
        ListViewType.table: m.Icons.table_bar,
      },
      onLongTap: onLongTap,
      //onFilterByChange: onFilterByChange,
      // onOrderByChange: onOrderByChange,
      // onSearchChange: onSearchChange,
      settings: settings,
      onOrderByChange: ((orderByChange) => BlocProvider.of<ModelsListBloc<T>>(
              context)
          .add(ModelsListChangeOrderBy<T>(
              orderByChange != null ? orderByChange.getSortOrders() : null))),
      onSearchChange: ((searchString) =>
          BlocProvider.of<ModelsListBloc<T>>(context)
              .add(ModelsListChangeSearchText<T>(searchString))),
      onFilterByChange: ((filter) => BlocProvider.of<ModelsListBloc<T>>(context)
          .add(ModelsListChangeFilter<T>(
              filter != null ? filter.getFilters() : null))),
    );
  }

  // Widget buildBlocLoading(BuildContext context, ModelsListLoading<T> state) {
  //   return Text("Loading");
  // }

  // Widget buildBlocError(BuildContext context, ModelsListNotLoaded<T> state) {
  //   return Text("Error occurred");
  // }
}
