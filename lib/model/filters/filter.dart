part of flutter_model;

abstract class Filter<T extends IModel> {
  String get key;
}

enum FilterComparison {
  equals,
  notequals,
  like,
  greaterthan,
  lessthan,
  isin
}

class FilterField<T extends IModel> extends Filter<T> {
  final dynamic value;
  final String fieldName;
  @override
  final String key;
  final bool isString;
  final String label;

  final FilterComparison comparison;
  FilterField(this.key, this.fieldName, this.value, this.comparison,
      this.isString, this.label);
}
