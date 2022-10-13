import 'package:flutter/material.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:flutter_model/widgets/ui/extended_list_view.dart';
import 'package:woue_components/woue_components.dart' as w;
import 'package:cbl/cbl.dart';
import 'package:cbl_flutter/cbl_flutter.dart';

void main() async {
  w.Woue.init(provider: w.MaterialProvider());
  await CouchbaseLiteFlutter.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    for (int i = 0; i < 25; i++) {
      dynamic parent = null;
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

  List<TableColumn> possibleColumns = [
    TableColumn(
        label: "Display Label",
        key: "displayLabel",
        onDisplay: (column, model, value, selected) =>
            Text(value == null ? "" : '$value  $selected'),
        onSort: (column, index, ascending) => print("Sorting"),
        tooltip: "This is the tooltip for the display label"),
    TableColumn(
        label: "Created On",
        key: "createdDate",
        onDisplay: (column, model, value, selected) =>
            Text(value == null ? "" : '$value'),
        onSort: (column, index, ascending) => print("Sorting"),
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
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () async {
                await _runDatabaseTest();
              },
              icon: Icon(Icons.data_array)),
          IconButton(
              onPressed: () async {
                await _runDbSync();
              },
              icon: Icon(Icons.sync))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                "To Do\n Tree view \n Multiple selections \n Property level on the column (although could still handle from the child) \n selecting grid count\n searching \n detailed searching by field\n sort order"),
            Row(children: [
              Text("Data Type"),
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
              Text("Show Search Bar"),
              Checkbox(
                  value: _showSearchBar,
                  onChanged: (value) => setState(() {
                        _showSearchBar = value ?? false;
                      }))
            ]),
            Row(
              children: [
                Text("Show Types:"),
                Text("View: "),
                Checkbox(
                    value: _showTypeView,
                    onChanged: (value) => setState(() {
                          _showTypeView = value ?? false;
                        })),
                Text("Grid: "),
                Checkbox(
                    value: _showTypeGrid,
                    onChanged: (value) => setState(() {
                          _showTypeGrid = value ?? false;
                        })),
                Text("List: "),
                Checkbox(
                    value: _showTypeList,
                    onChanged: (value) => setState(() {
                          _showTypeList = value ?? false;
                        })),
                Text("Tree: "),
                Checkbox(
                    value: _showTypeTree,
                    onChanged: (value) => setState(() {
                          _showTypeTree = value ?? false;
                        })),
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
  Sample? selected;
  String lastAction = "";

  List<Sample> itemsSample = [];
  List<HierarchyEntry<Sample>> hierarchySample = [];

  //List<SampleTree> itemsTree = [];

  Widget buildExtendedListView(BuildContext context) {
    List<ListViewType> types = [];
    if (_showTypeGrid) types.add(ListViewType.grid);
    if (_showTypeList) types.add(ListViewType.list);
    if (_showTypeView) types.add(ListViewType.table);
    if (_showTypeTree) types.add(ListViewType.tree);

    return ExtendedListView<Sample>(
      items: itemsSample,
      hierarchy: hierarchySample,
      enableSearch: _showSearchBar,
      enabledListTypes: types,
      selected: selected!=null?[selected!]:null,
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
        lastAction = "Search Changed : ${value}";
      }),
      tableColumns: possibleColumns,
    );
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
      print('Replicator activity: ${change.status.activity}');
    });

    await replicator.start();
  }

  Future<void> _runDatabaseTest() async {
    // Open the database (creating it if it doesn’t exist).
    final database = await Database.openAsync('my-database');

    // Create a new document.
    final mutableDocument = MutableDocument({'type': 'SDK', 'majorVersion': 2});
    await database.saveDocument(mutableDocument);

    print(
      'Created document with id ${mutableDocument.id} and '
      'type ${mutableDocument.string('type')}.',
    );

    // Update the document.
    mutableDocument.setString('Dart', key: 'language');
    await database.saveDocument(mutableDocument);

    print(
      'Updated document with id ${mutableDocument.id}, '
      'adding language ${mutableDocument.string("language")!}.',
    );

    // Read the document.
    final document = (await database.document(mutableDocument.id))!;

    print(
      'Read document with id ${document.id}, '
      'type ${document.string('type')} and '
      'language ${document.string('language')}.',
    );

    // Create a query to fetch documents of type SDK.
    print('Querying Documents of type=SDK.');
    final query = await Query.fromN1ql(database, '''
    SELECT * FROM _
    WHERE type = 'SDK'
  ''');

    // Run the query.
    final result = await query.execute();
    final results = await result.allResults();
    print('Number of results: ${results.length}');

    // Close the database.
    await database.close();
  }
}

class Sample extends IModel with IHierarchy {
  final dynamic id;
  final DateTime createdDate;
  final DateTime modifiedDate;
  final String displayLabel;
  final String description;
  final String url;
  final int numericValue;
  final dynamic hierarchyParentId;

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
