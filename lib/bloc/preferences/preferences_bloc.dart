import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/bloc/preferences/app_preference.dart';
import 'package:flutter_model/bloc/preferences/app_preference_store.dart';

import 'package:loggy/loggy.dart';

class PreferencesBloc<T extends IAppPreference>
    extends Bloc<PreferencesEvent<T>, PreferencesState<T>> with UiLoggy {
  final IAppPreferenceStore store;
  static Map<String, dynamic> getAllPreferences<T extends IAppPreference> (context) {
    try {
      var rtn = BlocProvider.of<PreferencesBloc<T>>(context).state.pref.values;

      return rtn;
    } catch (e) {
      logWarning("Unable to get all preferences $e");
    }
    return {};
  }

  PreferencesBloc(
    super.initialState, {
    required this.store,
  }) {
    on<PreferencesSetPreference<T>>(_handlePreferencesSetPreference);
    on<PreferencesReset<T>>(_handlePreferencesReset);
    on<PreferencesInit<T>>(_handlePreferencesInit);
  }
  Future<void> _handlePreferencesReset(
      PreferencesReset<T> event, Emitter<PreferencesState<T>> emit) async {
    loggy.debug("_handlePreferencesReset Started $event");
  }

  Future<void> _handlePreferencesSetPreference(
      PreferencesSetPreference<T> event,
      Emitter<PreferencesState<T>> emit) async {
    loggy.debug("_handlePreferencesSetPreference Started $event");
    for (var key in event.preferences.keys) {
      store.set(key, event.preferences[key]);
    }
    //Store from the settings....
    emitFromStore(emit);
  }

  void emitFromStore(Emitter<PreferencesState<T>> emit) {
    var settings = state.pref.copyWith(store.all());
    //AppEnvironment.pref = settings;
    emit(PreferencesLoaded<T>(settings));
  }

  Future<void> _handlePreferencesInit(
      PreferencesInit<T> event, Emitter<PreferencesState<T>> emit) async {
    loggy.debug("_handlePreferencesInit Started $event");

    emit(PreferencesLoading<T>(state.pref));
    //Firstly initialise the store so we can use it
    await store.init();

    //Now load the model from the store....
    emitFromStore(emit);
  }
}

abstract class PreferencesEvent<T extends IAppPreference>  {
  const PreferencesEvent();
}

/// Reset all the values to the default
class PreferencesReset<T extends IAppPreference> extends PreferencesEvent<T> {
  const PreferencesReset();
  @override
  List<Object?> get props => [];
}

/// Set a value for the preference
class PreferencesSetPreference<T extends IAppPreference>
    extends PreferencesEvent<T> {
  const PreferencesSetPreference(this.preferences);
  factory PreferencesSetPreference.single(String key, dynamic value) {
    return PreferencesSetPreference({key: value});
  }
  final Map<String, dynamic> preferences;

  @override
  List<Object?> get props => [preferences];

  @override
  String toString() => 'PreferencesSetPreference { preferences=$preferences  }';
}

class PreferencesInit<T extends IAppPreference> extends PreferencesEvent<T> {
  const PreferencesInit([this.pref]);

  final T? pref;

  @override
  List<Object?> get props => [pref];

  @override
  String toString() => 'PreferencesInit { preferences=$pref  }';
}

abstract class PreferencesState<T extends IAppPreference> {
  final T pref;
  const PreferencesState(this.pref);
  @override
  String toString() => '$runtimeType { $pref }';
}

/// called before the preferences are loaded
class PreferencesLoading<T extends IAppPreference> extends PreferencesState<T> {
  const PreferencesLoading(super.pref);
}

///the initial state
class PreferencesInitial<T extends IAppPreference> extends PreferencesState<T> {
  const PreferencesInitial(super.pref);
}

class PreferencesLoaded<T extends IAppPreference> extends PreferencesState<T> {
  const PreferencesLoaded(super.pref);
}
