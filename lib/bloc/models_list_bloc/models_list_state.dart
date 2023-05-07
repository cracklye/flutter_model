
//part 'model_state.freezed.dart';

import 'package:flutter_model/flutter_model.dart';

abstract class ModelsListState<T extends IModel> {
  ModelsListState({
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

class ModelsListLoading<T extends IModel> extends ModelsListState<T> {
  ModelsListLoading({
    super.parentId,
    super.selected,
    super.parameters,
    super.filters,
    super.orderBy,
    super.searchText, 
  });

  factory ModelsListLoading.fromState(ModelsListState<T> state,{  parentId, selected, parameters, filters, searchText, orderBy}) {
    return ModelsListLoading(
        parentId: parentId??state.parentId,
        selected: selected??state.selected,
        parameters: parameters??state.parameters,
        filters: filters??state.filters,
        searchText: searchText??state.searchText,
        orderBy: orderBy??state.orderBy);
  }
}

class ModelsListLoaded<T extends IModel> extends ModelsListState<T> {
  final List<T> models;
  final List<HierarchyEntry<T>> hierarchy;

  ModelsListLoaded({
    this.models = const [],
    this.hierarchy = const [],
    super.parentId,
    super.selected,
    super.parameters,
    super.filters,
    super.orderBy,
    super.searchText,
  });

  ModelsListLoaded<T> copyWith({
    List<T>? models,
    dynamic parentId,
    List<T>? selected,
    Map<String, dynamic>? parameters,
    List<HierarchyEntry<T>>? hierarchy,
    List<Filter>? filters,
    String? searchText, 
    List<SortOrderBy>? orderBy,
  }) {
    return ModelsListLoaded<T>(
        parentId: parentId ?? this.parentId,
        models: models ?? this.models,
        selected: selected ?? this.selected,
        hierarchy: hierarchy ?? this.hierarchy,
        filters: filters ?? this.filters,
        orderBy: orderBy ?? this.orderBy,
        searchText: searchText??this.searchText,
        parameters: parameters ?? this.parameters);
  }

  factory ModelsListLoaded.fromState(ModelsListState<T> state, {List<T>? models,
      List<HierarchyEntry<T>>? hierarchy, List<T>? selected}) {
    return ModelsListLoaded(
      parentId: state.parentId,
      selected: selected?? state.selected,
      parameters: state.parameters,
      filters: state.filters,
      orderBy: state.orderBy,
      searchText: state.searchText,
      hierarchy:
          hierarchy ?? ((state is ModelsListLoaded<T>) ? state.hierarchy : []),
      models: models ?? ((state is ModelsListLoaded<T>) ? state.models : []),
    );
  }
  @override
  String toString() {
    return "[ModelsLoaded \n    id:$parentId     \n selected: $selected \n     models:${models.length} \n     Search Text: $searchText d\n     parameters: $parameters\n     hierarchy:$hierarchy \n    orderBy:$orderBy \n    Filter: $filters] ";
  }
}

class ModelsListNotLoaded<T extends IModel> extends ModelsListState<T> {
  ModelsListNotLoaded({
    super.parentId,
    super.selected,
    super.parameters,
    super.filters,
    super.orderBy,
    super.searchText,
  });
  factory ModelsListNotLoaded.fromState(ModelsListState<T> state) {
    return ModelsListNotLoaded(
        parentId: state.parentId,
        selected: state.selected,
        parameters: state.parameters,
        filters: state.filters,
        searchText: state.searchText,
        orderBy: state.orderBy);
  }
}
