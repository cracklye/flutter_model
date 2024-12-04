//part 'model_state.freezed.dart';

import 'package:flutter_model/flutter_model.dart';

// abstract class ModelsState<T extends IModel> {}

// class ModelsLoading<T extends IModel> extends ModelsState<T> {
//   ModelsLoading();
// }

class HierarchyEntry<T> {
  final T item;
  final List<HierarchyEntry<T>> children = [];
  HierarchyEntry(
    this.item,
    //[this.children = const [] as List<HierarchyEntry<T>>]
  );
}

// enum ModelStateMode { view, edit }

// class ModelsLoaded<T extends IModel> extends ModelsState<T> {
//   //@Default(ModelStateMode.view)
//   final ModelStateMode mode;
//   final List<T> models;
//   final List<HierarchyEntry<T>> hierarchy;
//   final String? id;
//   final T? selected;
//   final Map<String, dynamic>? parameters;

//   ModelsLoaded({
//     this.mode = ModelStateMode.view,
//     this.models = const [],
//     this.hierarchy = const [],
//     this.id,
//     this.selected,
//     this.parameters,
//   });

//   ModelsLoaded<T> copyWith({
//     ModelStateMode? mode,
//     List<T>? models,
//     String? id,
//     T? selected,
//     Map<String, dynamic>? parameters,
//     List<HierarchyEntry<T>>? hierarchy,
//   }) {
//     return ModelsLoaded<T>(
//         id: id ?? this.id,
//         mode: mode ?? this.mode,
//         models: models ?? this.models,
//         selected: selected ?? this.selected,
//         hierarchy: hierarchy ?? this.hierarchy,
//         parameters: parameters ?? this.parameters);
//   }

//   // const ModelsLoaded(
//   //     [this.models = const [],
//   //     this.parentId,
//   //     this.id,
//   //     this.parameters,
//   //     this.selected]);
//   @override
//   String toString() {
//     return "[ModelsLoaded \n    id:$id     \n selected: $selected \n     mode: $mode \n     models:$models \n     parameters: $parameters\n     hierarchy:$hierarchy \n] ";
//   }
// }

// class ModelsNotLoaded<T extends IModel> extends ModelsState<T> {}

abstract class ModelsState<T extends IModel> {
  ModelsState({
    this.parentId,
    this.selected,
    this.parameters,
    this.filters,
    this.orderBy,
    this.searchText,
  });

  final dynamic parentId;
  final List<T>? selected;
  final Map<String, dynamic>? parameters;
  final List<Filter>? filters;
  final List<SortOrderBy>? orderBy;
  final String? searchText;
}

class ModelsLoading<T extends IModel> extends ModelsState<T> {
  ModelsLoading({
    super.parentId,
    super.selected,
    super.parameters,
    super.filters,
    super.orderBy,
    super.searchText,
  });

  factory ModelsLoading.fromState(ModelsState<T> state,
      {parentId, selected, parameters, filters, searchText, orderBy}) {
    return ModelsLoading(
        parentId: parentId ?? state.parentId,
        selected: selected ?? state.selected,
        parameters: parameters ?? state.parameters,
        filters: filters ?? state.filters,
        searchText: searchText ?? state.searchText,
        orderBy: orderBy ?? state.orderBy);
  }
}

class ModelsLoaded<T extends IModel> extends ModelsState<T> {
  final List<T> models;
  final List<HierarchyEntry<T>> hierarchy;

  ModelsLoaded({
    this.models = const [],
    this.hierarchy = const [],
    super.parentId,
    super.selected,
    super.parameters,
    super.filters,
    super.orderBy,
    super.searchText,
  });

  ModelsLoaded<T> copyWith({
    List<T>? models,
    dynamic parentId,
    List<T>? selected,
    Map<String, dynamic>? parameters,
    List<HierarchyEntry<T>>? hierarchy,
    List<Filter>? filters,
    String? searchText,
    List<SortOrderBy>? orderBy,
  }) {
    return ModelsLoaded<T>(
        parentId: parentId ?? this.parentId,
        models: models ?? this.models,
        selected: selected ?? this.selected,
        hierarchy: hierarchy ?? this.hierarchy,
        filters: filters ?? this.filters,
        orderBy: orderBy ?? this.orderBy,
        searchText: searchText ?? this.searchText,
        parameters: parameters ?? this.parameters);
  }

  factory ModelsLoaded.fromState(ModelsState<T> state,
      {List<T>? models,
      List<HierarchyEntry<T>>? hierarchy,
      List<T>? selected}) {
    return ModelsLoaded(
      parentId: state.parentId,
      selected: selected ?? state.selected,
      parameters: state.parameters,
      filters: state.filters,
      orderBy: state.orderBy,
      searchText: state.searchText,
      hierarchy:
          hierarchy ?? ((state is ModelsLoaded<T>) ? state.hierarchy : []),
      models: models ?? ((state is ModelsLoaded<T>) ? state.models : []),
    );
  }
  @override
  String toString() {
    return "[ModelsLoaded \n    id:$parentId     \n selected: $selected \n     models:${models.length} \n     Search Text: $searchText d\n     parameters: $parameters\n     hierarchy:$hierarchy \n    orderBy:$orderBy \n    Filter: $filters] ";
  }
}

class ModelsNotLoaded<T extends IModel> extends ModelsState<T> {
  ModelsNotLoaded({
    super.parentId,
    super.selected,
    super.parameters,
    super.filters,
    super.orderBy,
    super.searchText,
  });
  factory ModelsNotLoaded.fromState(ModelsState<T> state) {
    return ModelsNotLoaded(
        parentId: state.parentId,
        selected: state.selected,
        parameters: state.parameters,
        filters: state.filters,
        searchText: state.searchText,
        orderBy: state.orderBy);
  }
}



// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:imageffi/model/persist/imodel.dart';
//   part 'model_state.freezed.dart';


// abstract class ModelsState<T extends IModel> {
  
// }

// class ModelsLoading<T extends IModel> extends ModelsState<T> {
//    ModelsLoading();
// }

// enum ModelStateMode {view, edit}

// @Freezed()
// class ModelsLoaded<T extends IModel> with _$ModelsLoaded<T>, ModelsState<T> {
//   factory ModelsLoaded({
    
    
//     @Default(ModelStateMode.view) ModelStateMode mode , 

//     @Default([]) List<T> models,
    
//     String? id,
//     T? selected,
//     Map<String, dynamic>? parameters,

//   }) = _ModelsLoaded;

//   // const ModelsLoaded(
//   //     [this.models = const [],
//   //     this.parentId,
//   //     this.id,
//   //     this.parameters,
//   //     this.selected]);
// }

// class ModelsNotLoaded<T extends IModel> extends ModelsState<T> {}
