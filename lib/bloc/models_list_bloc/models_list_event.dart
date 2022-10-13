part of flutter_model;

abstract class ModelsListEvent<T extends IModel> {
  const ModelsListEvent();
}

/// This class is designed for use when you wish to
/// select a model in this state.
class ModelListSelect<T extends IModel> extends ModelsListEvent<T> {
  /// The model to select
  final T? model;

  /// Whether you wish to append the selection to any currently selected items or not.
  final bool appendToSelection;

  ModelListSelect([this.model, this.appendToSelection = false]);
}




/// Raised when the selection criteria is changed or when the models need to
/// be loaded for the first time.
class ModelsListLoad<T extends IModel> extends ModelsListEvent<T> {
  /// The parent ID that has been set to filter by
  final dynamic parentId;

  /// Whether to clear the selection
  final bool clear;

  /// A list of filters to apply to the selection
  final List<Filter>? filters;

  /// A list of order by items to use to order the selections
  final List<SortOrderBy>? orderBy;

  final String? searchtext; 

  const ModelsListLoad(
      {this.parentId, this.filters, this.orderBy, this.clear = false, this.searchtext});
}

/// Raised when a document needs to be deleted
class ModelsListDelete<T extends IModel> extends ModelsListEvent<T> {
  /// The model to delete
  final T model;

  const ModelsListDelete(this.model);
}

/// Raised when the edit mode is to be changed.  Not sure this is what we really care about?
///
class ModelsListUpdateList<T extends IModel> extends ModelsListEvent<T> {
  final List<T> models;
  const ModelsListUpdateList(this.models);
}


class ModelsListChangeSearchText<T extends IModel> extends ModelsListEvent<T> {
  final String? searchText;
  const ModelsListChangeSearchText(this.searchText);
}
class ModelsListChangeOrderBy<T extends IModel> extends ModelsListEvent<T> {
  final List<SortOrderBy>?  sortOrders;
  const ModelsListChangeOrderBy(this.sortOrders);
}

class ModelsListChangeFilter<T extends IModel> extends ModelsListEvent<T> {
  final List<Filter<T>>? filters;
  const ModelsListChangeFilter(this.filters);
}