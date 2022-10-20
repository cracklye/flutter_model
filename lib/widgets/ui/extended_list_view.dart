part of flutter_model;

enum ListViewType {
  tree,
  list,
  grid,
  table,
}

class OrderByItem {
  final Widget label;
  final List<SortOrderBy> Function() getSortOrders;

  OrderByItem(this.label, this.getSortOrders);
}

class FilterByItem<T extends IModel> {
  final Widget label;
  final List<Filter<T>> Function() getFilters;
  FilterByItem(this.label, this.getFilters);
}

enum TableColumnType { image, text, numeric, link }

class TableColumn<T extends IModel> {
  final String label;
  final String key;
  final String? tooltip;
  final Function(TableColumn, int, bool)? onSort;
  final Function(TableColumn, T, dynamic, bool)? onDisplay;

  TableColumn(
      {required this.label,
      required this.key,
      this.tooltip,
      this.onSort,
      this.onDisplay});
}

class ExtendedListView<T extends IModel> extends StatefulWidget {
  ExtendedListView({
    super.key,
    this.selected,
    required this.items,
    this.hierarchy,
    this.enabledListTypes = ListViewType.values,
    this.orderBy,
    this.filterBy,
    this.tableColumns,
    this.buildGridItem,
    this.buildTreeItem,
    this.buildListItem,
    this.buildTableColumn,
    this.buildToolbarSub,
    this.onOrderByChange,
    this.onFilterByChange,
    this.onSearchChange,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
    this.isLoading = false,
    this.enableSearch = true,
    this.listTypesIcons = const {
      ListViewType.grid: m.Icons.grid_3x3,
      ListViewType.list: m.Icons.list,
      ListViewType.tree: m.Icons.thermostat_rounded,
      ListViewType.table: m.Icons.table_bar,
    },
    this.defaultSearchText,
    String? settingsKey,
    SettingsStorage? settings,
  }) : settingsStorer = (settings == null && settingsKey != null)
            ? SharedPreferencesSettings(settingsKey)
            : settings;

  @override
  State<ExtendedListView<T>> createState() => _ExtendedListViewState<T>();
  final List<T>? selected;
  final List<T> items;
  final List<HierarchyEntry<T>>? hierarchy;

  final bool enableSearch;

  final List<ListViewType> enabledListTypes;
  final Map<ListViewType, IconData> listTypesIcons;

  final List<OrderByItem>? orderBy;
  final List<FilterByItem<T>>? filterBy;
  final List<TableColumn>? tableColumns;

  final bool isLoading;

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

  final Widget Function(BuildContext)? buildToolbarSub;

  final SettingsStorage? settingsStorer;

  final String? defaultSearchText;
}

abstract class SettingsStorage {
  Future<double> getGridColumns([double defaultValue = 5]);
  Future<ListViewType> getListViewType(
      [ListViewType defaultValue = ListViewType.list]);
  Future<String> getSearchString();
  Future<void> setgridColumns(
    double gridColumns,
  );
  Future<void> setSearchString(String searchString);
  Future<void> setGridListViewType(ListViewType listViewType);
}

class SharedPreferencesSettings extends SettingsStorage {
  final String key;
  SharedPreferencesSettings(this.key);

  @override
  Future<double> getGridColumns([double defaultValue = 5]) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("$key.grid") ?? defaultValue;
  }

  @override
  Future<ListViewType> getListViewType(
      [ListViewType defaultValue = ListViewType.list]) async {
    final prefs = await SharedPreferences.getInstance();
    String? lookup = prefs.getString("$key.listviewtype");
    try {
      return ListViewType.values
          .firstWhere((element) => element.toString() == lookup);
    } catch (e) {
      print(e);
    }
    return defaultValue;
  }

  @override
  Future<String> getSearchString() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("$key.searchstring") ?? "";
  }

  @override
  Future<void> setGridListViewType(ListViewType listViewType) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("$key.listviewtype", listViewType.toString());
  }

  @override
  Future<void> setSearchString(String searchString) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("$key.searchstring", searchString);
  }

  @override
  Future<void> setgridColumns(double gridColumns) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble("$key.grid", gridColumns);
  }
}

class _ExtendedListViewState<T extends IModel>
    extends State<ExtendedListView<T>> {
  late ListViewType _listViewType;
  late TextEditingController _searchController;
  late double _gridColumns;

  @override
  void initState() {
    _listViewType = ListViewType.list;
    _gridColumns = 4;
    _searchController = TextEditingController();
    _searchController.text = (widget.defaultSearchText ?? "");

    if (widget.settingsStorer != null) {
      //_listViewType =
      widget.settingsStorer!.getListViewType().then((value) {
        print("Updating the list view type from settings $value");
        setState(() {
          _listViewType = value;
        });
      });
      widget.settingsStorer!.getGridColumns().then((value) {
        print("Updating the grid columnsS from settings $value");
        setState(() {
          _gridColumns = value;
        });
      });

      //_gridColumns =  widget.settingsStorer!.getGridColumns();
    } else {}

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildToolbar(context),
        (widget.buildToolbarSub != null)
            ? widget.buildToolbarSub!(context)
            : Container(),
        //Expanded(child: SingleChildScrollView(child: buildContent(context))),
        Expanded(child:  buildContent(context)),
        (_listViewType == ListViewType.grid)
            ? buildFooter(context)
            : Container(),
      ],
    );
  }

  Widget buildFooter(BuildContext context) {
    List<Widget> w = [];
    if (_listViewType == ListViewType.grid) {
      w.add(Slider(
          value: _gridColumns,
          min: 2,
          max: 10,
          onChanged: ((p0) async {
            if (widget.settingsStorer != null) {
              widget.settingsStorer!.setgridColumns(p0);
            }
            setState(() {
              _gridColumns = p0;
            });
          })));
    }

    return SizedBox(
        height: 35,
        child: Row(children: [Expanded(child: Text("Footer")), ...w]));
  }

  Widget buildContent(BuildContext context) {
    if (widget.isLoading) {
      //TODO need to add loading symbol
      return Text("Loading");
    }
    if (widget.items.isEmpty) {
      //TODO need to format this a bit better (make it customisable)
      return Text("No matching entries");
    }

    if (_listViewType == ListViewType.grid) {
      return buildContentGrid(context);
    } else if (_listViewType == ListViewType.list) {
      return buildContentList(context);
    } else if (_listViewType == ListViewType.tree) {
      return buildContentTree(context);
    }
    return buildContentTable(context);
  }

  Widget buildContentList(BuildContext context) {
    return ListView.builder(
      //  shrinkWrap: true,
        //  physics: const NeverScrollableScrollPhysics(),

        itemCount: widget.items.length,
        itemBuilder: ((context, index) =>
            // widget.buildListItem == null
            //         ? buildListItemDefault(context, widget.items[index])
            //         : widget.buildListItem!(context, widget.items[index])

            GestureDetector(
                onTap: widget.onTap == null
                    ? null
                    : () => widget.onTap!(widget.items[index]),
                onDoubleTap: widget.onDoubleTap == null
                    ? null
                    : () => widget.onDoubleTap!(widget.items[index]),
                onLongPress: widget.onLongTap == null
                    ? null
                    : () => widget.onLongTap!(widget.items[index]),
                child: widget.buildListItem == null
                    ? buildListItemDefault(context, widget.items[index])
                    : widget.buildListItem!(context, widget.items[index]))));
  }

  Widget buildListItemDefault(BuildContext context, T item) {
    return ListTile(
        title: Text(
          item.displayLabel,
          overflow: TextOverflow.ellipsis,
        ),
        leading: SizedBox(
          width: 2,
          child: Container(
              color: widget.selected == item
                  ? m.Colors.red
                  : m.Colors.transparent),
        ));
  }

  Widget buildContentGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: _gridColumns.toInt(),
     // shrinkWrap: true,
      children: widget.items
          .map((e) => GestureDetector(
              onTap: widget.onTap == null ? null : () => widget.onTap!(e),
              onDoubleTap: widget.onDoubleTap == null
                  ? null
                  : () => widget.onDoubleTap!(e),
              onLongPress:
                  widget.onLongTap == null ? null : () => widget.onLongTap!(e),
              child: widget.buildGridItem == null
                  ? buildGridItemDefault(context, e)
                  : widget.buildGridItem!(context, e)))
          .toList(),
    );
  }

  Widget buildGridItemDefault(BuildContext context, T item) {
    return GridCardDefault(title: item.displayLabel);
  }

  Widget buildContentTree(BuildContext context) {
    return Text("Need to implement Tree");
  }

  Widget buildContentTable(BuildContext context) {
    if (widget.tableColumns != null && widget.tableColumns!.isNotEmpty) {
      // Build the columns
      List<m.DataColumn> cols = [];

      for (var col in widget.tableColumns!) {
        cols.add(m.DataColumn(
            label: Text(col.label),
            onSort: col.onSort == null
                ? null
                : ((columnIndex, ascending) =>
                    col.onSort!(col, columnIndex, ascending)),
            tooltip: col.tooltip));
      }

      List<m.DataRow> rows = [];
      for (var row in widget.items) {
        Map<String, dynamic> json = row.toJson();

        List<m.DataCell> cells = [];
        for (var col in widget.tableColumns!) {
          dynamic val = json[col.key];
          Widget celW;

          if (col.onDisplay != null) {
            //     cells.add(m.DataCell(Text(val?.toString()??"")));
            celW = col.onDisplay!(col, row, val, row == widget.selected);
          } else {
            celW = Text('$val');
          }
          cells.add(
            m.DataCell(celW,
                onTap: widget.onTap == null ? null : () => widget.onTap!(row),
                onDoubleTap: widget.onDoubleTap == null
                    ? null
                    : () => widget.onDoubleTap!(row),
                onLongPress: widget.onLongTap == null
                    ? null
                    : () => widget.onLongTap!(row)),
          );
        }
        rows.add(m.DataRow(cells: cells, selected: row == widget.selected));
      }

      return m.Material(
          child: m.DataTable(
        columns: cols,
        rows: rows,
      ));
    }
    return Text("No columns configured");
  }

  Widget buildToolbar(BuildContext context) {
    List<Widget> btns = [];
    if (widget.onOrderByChange != null && widget.orderBy != null) {
      if (widget.orderBy!.length > 1) {
        for (var ob in widget.orderBy!) {
          btns.add(ElevatedButton(
            child: ob.label,
            onPressed: () => widget.onOrderByChange!(ob),
          ));
        }
      }
    }

    return Row(
      children: [
        Expanded(
          child: buildSearchBox(context),
        ),
        ...btns,
        ...widget.enabledListTypes
            .map<Widget>(
              (e) =>
                  buildSelectViewButton(context, e, widget.listTypesIcons[e]),
            )
            .toList(),
      ],
    );
  }

  Widget buildSearchBox(BuildContext context) {
    if (widget.enableSearch) {
      return Row(
        children: [
          const Icon(m.Icons.search),
          Expanded(
              child: m.Material(
                  child: m.TextFormField(
            controller: _searchController,
            onChanged: (value) {
              if (widget.onSearchChange != null) {
                widget.onSearchChange!(value);
              }
            },
          )))
        ],
      );
    }
    return Container();
  }

  Widget buildSelectViewButton(
      BuildContext context, ListViewType type, IconData? icon) {
    if (type == ListViewType.table &&
        (widget.tableColumns == null || widget.tableColumns!.isEmpty)) {
      return Container();
    }
    if (type == ListViewType.tree &&
        (widget.hierarchy == null || widget.hierarchy!.isEmpty)) {
      return Container();
    }

    if (widget.enabledListTypes.contains(type)) {
      if (_listViewType == type) {
        return Icon(icon);
      } else {
        return IconButton(
            onPressed: () => _selectViewType(type), icon: Icon(icon));
      }
    } else {
      return Container();
    }
  }

  _selectViewType(ListViewType viewType) async {
    if (widget.settingsStorer != null) {
      await widget.settingsStorer!.setGridListViewType(viewType);
    }
    setState(() {
      _listViewType = viewType;
    });
  }
}
