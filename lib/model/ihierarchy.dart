
import 'package:flutter_model/flutter_model.dart';

abstract class IHierarchy {

  dynamic get hierarchyParentId; 
}



class HierarchyHelper{
  
  static List<HierarchyEntry<T>> computeHierarchy<T extends IModel>(List<T> models) {
    //Select the root ones....
   
    var root = models.where((element) =>
        (element as IHierarchy).hierarchyParentId == null ||
        (element as IHierarchy).hierarchyParentId == "");
    List<HierarchyEntry<T>> rtn = [];

    for (var rootModel in root) {
      var h = HierarchyEntry<T>(rootModel);
      _computeHierarchyChild<T>(models, h);
      rtn.add(h);
    }

    return rtn;
  }

  static void _computeHierarchyChild<T extends IModel>(List<T> models, HierarchyEntry<T> parent) {
    var matches = models.where((element) =>
        (element as IHierarchy).hierarchyParentId == parent.item.id);
    for (var model in matches) {
      var h = HierarchyEntry<T>(model);
      _computeHierarchyChild<T>(models, h);
      parent.children.add(h);
    }
  }

}