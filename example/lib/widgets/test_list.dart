import 'package:flutter/material.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:cbl/cbl.dart';
import 'package:loggy/loggy.dart';
import 'package:woue_components/woue_components.dart' as w;
import 'package:woue_components_material/material_provider.dart' as mp;

class TestList<T extends IModel> extends StatefulWidget {
  const TestList({super.key, required this.initialItems});

  final List<T> initialItems;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<TestList<T>> createState() => _MyHomePageState();
}

class _MyHomePageState<T extends IModel> extends State<TestList<T>>
    with UiLoggy {
  @override
  void initState() {
    // for (int i = 0; i < 25; i++) {
    //   dynamic parent;
    //   if (i > 6) {
    //     parent = ((i - 6 / 3)).toInt();
    //   }
    //   itemsSample.add(Sample(i, DateTime.now(), DateTime.now(), "Item $i",
    //       "This is the description to use $i", "", i, parent));
    // }
    itemsSample = widget.initialItems;
    //Set the hierarchy
    hierarchySample = HierarchyHelper.computeHierarchy(itemsSample);
    super.initState();
  }

  List<TableColumn> possibleColumns = [
    TableColumn(
        label: "Display Label",
        key: "displayLabel",
        onDisplay: (column, model, value, selected) =>
            Text(value == null ? "" : '$value  $selected'),
        onSort: (column, index, ascending) => logInfo("Sorting"),
        tooltip: "This is the tooltip for the display label"),
    TableColumn(
        label: "Created On",
        key: "createdDate",
        onDisplay: (column, model, value, selected) =>
            Text(value == null ? "" : '$value'),
        onSort: (column, index, ascending) => logInfo("Sorting"),
        tooltip: "This is the tooltip for the created on"),
    TableColumn(
        label: "Modified no sort",
        key: "modifiedDate",
        onDisplay: (column, model, value, selected) =>
            Text(value == null ? "" : '$value'),
        tooltip: "This is the tooltip for the created on"),
    TableColumn(
      label: "Numeriv Value",
      key: "numericValue",
      onDisplay: (column, model, value, selected) =>
          Text(value == null ? "" : '$value'),
    ),
    TableColumn(
      label: "Doesn't Exist",
      key: "Doesn't exist",
      onDisplay: (column, model, value, selected) =>
          Text(value == null ? "" : '$value'),
    ),
    TableColumn(
      label: "Properties Vlaue",
      key: "properties.propvalue",
      onDisplay: (column, model, value, selected) =>
          Text(value == null ? "" : '$value'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test ExtendedList"),
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
                "To Do\n Tree view \n Multiple selections \n Property level on the column (although could still handle from the child) \n selecting grid count\n searching \n detailed searching by field\n sort order"),
            Row(children: [
              const Text("Data Type"),
              Radio(
                  groupValue: true,
                  value: _showTreeData,
                  onChanged: (value) => setState(() {
                        _showTreeData = true;
                      })),
              Radio(
                  groupValue: true,
                  value: !_showTreeData,
                  onChanged: (value) => setState(() {
                        _showTreeData = false;
                      }))
            ]),
            Row(children: [
              const Text("Show Search Bar"),
              Checkbox(
                  value: _showSearchBar,
                  onChanged: (value) => setState(() {
                        _showSearchBar = value ?? false;
                      })),
              const Text("Is Loading: "),
              Checkbox(
                  value: _isLoading,
                  onChanged: (value) => setState(() {
                        _isLoading = value ?? false;
                      })),
            ]),
            Row(
              children: [
                const Text("Show Types:         "),
                const Text("| View: "),
                Checkbox(
                    value: _showTypeView,
                    onChanged: (value) => setState(() {
                          _showTypeView = value ?? false;
                        })),
                const Text("| Grid: "),
                Checkbox(
                    value: _showTypeGrid,
                    onChanged: (value) => setState(() {
                          _showTypeGrid = value ?? false;
                        })),
                const Text("| Map: "),
                Checkbox(
                    value: _showTypeMap,
                    onChanged: (value) => setState(() {
                          _showTypeMap = value ?? false;
                        })),
                const Text("| Drag: "),
                Checkbox(
                    value: _showTypeDrag,
                    onChanged: (value) => setState(() {
                          _showTypeDrag = value ?? false;
                        })),
                const Text("| List: "),
                Checkbox(
                    value: _showTypeList,
                    onChanged: (value) => setState(() {
                          _showTypeList = value ?? false;
                        })),
                const Text("| Tree: "),
                Checkbox(
                    value: _showTypeTree,
                    onChanged: (value) => setState(() {
                          _showTypeTree = value ?? false;
                        })),
                const Text("| "),
              ],
            ),
            Text("Last Action: $lastAction"),
            Expanded(child: buildExtendedListView(context)),
          ],
        ),
      ),
    );
  }

  bool _showTreeData = true;
  bool _showSearchBar = true;
  bool _showTypeView = true;
  bool _showTypeGrid = true;
  bool _showTypeList = true;
  bool _showTypeTree = true;
  bool _showTypeDrag = true;
  bool _showTypeMap = true;

  bool _isLoading = false;

  T? selected;
  String lastAction = "";

  List<T> itemsSample = [];
  List<HierarchyEntry<T>> hierarchySample = [];

  //List<SampleTree> itemsTree = [];

  Widget buildExtendedListView(BuildContext context) {
    List<ListViewType> types = [];
    if (_showTypeGrid) types.add(ListViewType.grid);
    if (_showTypeList) types.add(ListViewType.list);
    if (_showTypeView) types.add(ListViewType.table);
    if (_showTypeTree) types.add(ListViewType.tree);
    if (_showTypeDrag) types.add(ListViewType.sortable);
    if (_showTypeMap) types.add(ListViewType.map);

    return ExtendedListView<T>(
      isLoading: _isLoading,
      items: itemsSample,
      hierarchy: hierarchySample,
      enableSearch: _showSearchBar,
      enabledListTypes: types,
      selected: selected != null ? [selected!] : null,
      onTap: (model) {
        setState(() {
          lastAction = "onTap : ${model.displayLabel}";
          selected = model;
        });
      },
      onDoubleTap: (model) {
        setState(() {
          lastAction = "onDoubleTap : ${model.displayLabel}";
          selected = model;
        });
      },
      onLongTap: (model) {
        setState(() {
          lastAction = "onLongTap : ${model.displayLabel}";
          selected = model;
        });
      },
      onSearchChange: (value) => setState(() {
        lastAction = "Search Changed : $value";
      }),
      onReorder: ((previousPosition, newPosition, item, before, after,
              parent) =>
          print(
              "On Reorder: Moving $item  from $previousPosition to $newPosition between $before and $after")),
      tableColumns: possibleColumns,
    );
  }
}
