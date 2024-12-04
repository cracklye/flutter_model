import 'package:cbl/cbl.dart' as cbl;
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:example/app_settings.dart';
import 'package:example/dailyaction/model_dailyaction.dart';
import 'package:example/notes/model_notes.dart';
import 'package:example/repos/notes_repo_couchbase.dart';
import 'package:example/repos/notes_repo_inmemory.dart';
import 'package:example/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/app_environement.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:loggy/loggy.dart';

cbl.Database? database;

/// This is the method that creates the indexes required by this application
/// It should be called when starting the application, but can also
/// be called via the bloc if that is required.
Future<void> createFTIndexes(cbl.Database database) async {
  var fti = cbl.FullTextIndexConfiguration([
    "name",
    "title",
    "content",
    "description",
    "tags",
    "text",
    "label",
    "properties"
  ], language: cbl.FullTextLanguage.english);
  await (await database.defaultCollection).deleteIndex("fti");
  await (await database.defaultCollection).createIndex("fti", fti);
}

void main() async {
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
    logOptions: LogOptions(
      AppEnvironment.isDebug ? LogLevel.all : LogLevel.warning,
      stackTraceLevel: LogLevel.warning,
    ),
    filters: [
      //BlacklistFilter([BlacklistedLoggy]),
    ],
  );

  await CouchbaseLiteFlutter.init();
  //cbl.Database.log.custom!.level = cbl.LogLevel.verbose;
//cbl.Database.log.console.leve = cbl.LogDomain.replicator;
//  cbl.Database.log.console.level = cbl.LogLevel.verbose;

  String dbname = "note_dev_mobile";
  database = await cbl.Database.openAsync(dbname);

  await createFTIndexes(database!);

  // Ensure the binding is initialised
  WidgetsFlutterBinding.ensureInitialized();

  AppRouter.setupRouter();

  //await CouchbaseLiteFlutter.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return buildRepoProviders(context);
  }

  Widget buildRepoProviders(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider<IModelAPI<Notes>>(
        create: (context) => NotesDaoCouchbase(database!)..init(),
      ),
      RepositoryProvider<IModelAPI<DailyAction>>(
        create: (context) => RepositoryDailyActionMemory([
          DailyAction(
              id: "1", name: "daily 1", description: "This is the first daily"),
          DailyAction(
              id: "2", name: "daily 2", description: "This is the first tiem"),
          DailyAction(
              id: "3", name: "daily 3", description: "This is the first tiem"),
          DailyAction(
              id: "4", name: "daily 4", description: "This is the first tiem"),
          DailyAction(
              id: "5", name: "daily 5", description: "This is the first tiem"),
        ])
          ..init(),
      )
    ], child: buildProviders(context));
  }

  // This widget is the root of your application.

  Widget buildProviders(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<PreferencesBloc<AppSettings>>(
          create: (context) => PreferencesBloc<AppSettings>(
              PreferencesInitial(AppSettings()),
              store: AppPrefStoreSharedPreferences())
            ..add(const PreferencesInit<AppSettings>())),
      BlocProvider<ModelsBloc<Notes>>(
          create: (context) => ModelsBloc<Notes>(
                modelsRepository:
                    RepositoryProvider.of<IModelAPI<Notes>>(context),
              )..add(const ModelsLoad<Notes>())),
      BlocProvider<ModelsBloc<DailyAction>>(
          create: (context) => ModelsBloc<DailyAction>(
                modelsRepository:
                    RepositoryProvider.of<IModelAPI<DailyAction>>(context),
              )..add(const ModelsLoad<DailyAction>())),
    ], child: buildApp(context));
  }

  Widget buildApp(BuildContext context) {
    return BlocBuilder<PreferencesBloc<AppSettings>,
            PreferencesState<AppSettings>>(
        builder: (context, state) => MaterialApp(
              title: 'Flutter Model Test App',
              themeMode: state.pref.darkMode ? ThemeMode.dark : ThemeMode.light,
              theme: ThemeData(
                brightness: Brightness.light,
                /* light theme settings */
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                /* dark theme settings */
              ),
              debugShowCheckedModeBanner: false,
              onGenerateRoute: AppRouter.router.generator,
            ));
  }
}
