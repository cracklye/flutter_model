
import 'package:example/routes/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:cbl/cbl.dart';
import 'package:loggy/loggy.dart';

class TestViewScreen extends StatefulWidget {
  const TestViewScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<TestViewScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TestViewScreen> with UiLoggy {
  @override
  void initState() {
    for (int i = 0; i < 25; i++) {
      dynamic parent;
      if (i > 6) {
        parent = ((i - 6 / 3)).toInt();
      }

      itemsSample.add(Sample(i, DateTime.now(), DateTime.now(), "Item $i",
          "This is the description to use $i", "", i, parent));
    }
    //Set the hierarchy
    hierarchySample = HierarchyHelper.computeHierarchy(itemsSample);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () async {
                await _runDatabaseTest();
              },
              icon: const Icon(Icons.data_array)),
          IconButton(
              onPressed: () async {
                await _runDbSync();
              },
              icon: const Icon(Icons.sync))
        ],
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

  Sample? selected;
  String lastAction = "";

  List<Sample> itemsSample = [];
  List<HierarchyEntry<Sample>> hierarchySample = [];

  //List<SampleTree> itemsTree = [];

  Widget buildExtendedListView(BuildContext context) {
    return const Text("Need to extended");
    // List<ListViewType> types = [];
    // if (_showTypeGrid) types.add(ListViewType.grid);
    // if (_showTypeList) types.add(ListViewType.list);
    // if (_showTypeView) types.add(ListViewType.table);
    // if (_showTypeTree) types.add(ListViewType.tree);
    // if (_showTypeDrag) types.add(ListViewType.sortable);
    // if (_showTypeMap) types.add(ListViewType.map);

    // return ExtendedListView<Sample>(
    //   isLoading: _isLoading,
    //   items: itemsSample,
    //   hierarchy: hierarchySample,
    //   enableSearch: _showSearchBar,
    //   enabledListTypes: types,
    //   selected: selected != null ? [selected!] : null,
    //   onTap: (model) {
    //     setState(() {
    //       lastAction = "onTap : ${model.displayLabel}";
    //       selected = model;
    //     });
    //   },
    //   onDoubleTap: (model) {
    //     setState(() {
    //       lastAction = "onDoubleTap : ${model.displayLabel}";
    //       selected = model;
    //     });
    //   },
    //   onLongTap: (model) {
    //     setState(() {
    //       lastAction = "onLongTap : ${model.displayLabel}";
    //       selected = model;
    //     });
    //   },
    //   onSearchChange: (value) => setState(() {
    //     lastAction = "Search Changed : $value";
    //   }),
    //   onReorder: ((previousPosition, newPosition, item, before, after,
    //           parent) =>
    //       print(
    //           "On Reorder: Moving $item  from $previousPosition to $newPosition between $before and $after")),
    //   tableColumns: possibleColumns,
    // );
  }

  Future<void> _runDbSync() async {
    final database = await Database.openAsync('my-database');

    final replicator = await Replicator.create(ReplicatorConfiguration(
      authenticator:
          BasicAuthenticator(username: "administrator", password: "letmein123"),
      database: database,
      target: UrlEndpoint(Uri.parse('ws://localhost:4984/testbucket')),
    ));

    await replicator.addChangeListener((change) {
      loggy.info('Replicator activity: ${change.status.activity}');
    });

    await replicator.start();
  }

  Future<void> _runDatabaseTest() async {
    // Open the database (creating it if it doesn’t exist).
    final database = await Database.openAsync('my-database');

    // Create a new document.
    final mutableDocument = MutableDocument({'type': 'SDK', 'majorVersion': 2});
    await database.saveDocument(mutableDocument);

    loggy.info(
      'Created document with id ${mutableDocument.id} and '
      'type ${mutableDocument.string('type')}.',
    );

    // Update the document.
    mutableDocument.setString('Dart', key: 'language');
    await database.saveDocument(mutableDocument);

    loggy.info(
      'Updated document with id ${mutableDocument.id}, '
      'adding language ${mutableDocument.string("language")!}.',
    );

    // Read the document.
    final document = (await database.document(mutableDocument.id))!;

    loggy.info(
      'Read document with id ${document.id}, '
      'type ${document.string('type')} and '
      'language ${document.string('language')}.',
    );

    // Create a query to fetch documents of type SDK.
    loggy.info('Querying Documents of type=SDK.');
    final query = await Query.fromN1ql(database, '''
    SELECT * FROM _
    WHERE type = 'SDK'
  ''');

    // Run the query.
    final result = await query.execute();
    final results = await result.allResults();
    loggy.info('Number of results: ${results.length}');

    // Close the database.
    await database.close();
  }
}

class Sample extends IModel with IHierarchy {
  @override
  final dynamic id;
  @override
  final DateTime createdDate;
  @override
  final DateTime modifiedDate;
  @override
  final String displayLabel;
  final String description;
  final String url;
  final int numericValue;
  @override
  final dynamic hierarchyParentId;

  @override
  String toString() {
    return "Item $id";
  }

  Sample(this.id, this.createdDate, this.modifiedDate, this.displayLabel,
      this.description, this.url, this.numericValue, this.hierarchyParentId);

  @override
  IModel copyWithId({id, DateTime? createdDate, DateTime? modifiedDate}) {
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "createdDate": createdDate,
      "modifiedDate": modifiedDate,
      "displayLabel": displayLabel,
      "description": description,
      "numericValue": numericValue,
      "hierarchyParentId": hierarchyParentId,
      "url": url
    };
  }
}
