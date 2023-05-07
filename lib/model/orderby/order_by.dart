
abstract class SortOrderBy {  
  
  String get key;
}

class SortOrderByFieldName  extends SortOrderBy{
  final String fieldName;
  final bool ascending;
  @override
  final String key ;

  SortOrderByFieldName(this.key, this.fieldName, this.ascending);


}
