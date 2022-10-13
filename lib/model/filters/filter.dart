part of flutter_model;

abstract class Filter<T extends IModel> {
  String get key;
}


enum FilterComparison{
  equals, notequals, like, greaterthan, lessthan, 
}
class FilterField<T extends IModel>  extends Filter<T>{
  final dynamic value;
  final String fieldName;
  final String key;
  final bool isString; 
final FilterComparison comparison;
  FilterField(this.key, this.fieldName, this.value, this.comparison, this.isString);
}
