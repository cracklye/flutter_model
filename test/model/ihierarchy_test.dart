import 'package:flutter_model/flutter_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/test_model.dart';

void main() {
  var testModels = [
    TestModel(name: "Test1", id: "1", hierarchyParentId: null),
    TestModel(name: "Test 2", id: "2", hierarchyParentId: null),
    TestModel(name: "Test 3", id: "3", hierarchyParentId: null),
    TestModel(name: "Test 4", id: "4", hierarchyParentId: null),
    TestModel(name: "Test1.1", id: "5", hierarchyParentId: "1"),
    TestModel(name: "Test1.2", id: "6", hierarchyParentId: "1"),
    TestModel(name: "Test1.1.1", id: "7", hierarchyParentId: "5"),
    TestModel(name: "Test1.1.1.1", id: "8", hierarchyParentId: "7"),
    TestModel(name: "Test1.3", id: "9", hierarchyParentId: "1"),
    TestModel(name: "Test1.2.1", id: "10", hierarchyParentId: "6"),
  ];
  test('hierarchy helper computes hierarchy', () {
    var h = HierarchyHelper.computeHierarchy<TestModel>(testModels);
    expect(h, isNotNull);
    expect(h.length, 4);
    expect(h[0].children.length, 3);
    expect(h[1].children.length, 0);
    expect(h[2].children.length, 0);
    expect(h[3].children.length, 0);
    expect(h[0].children[0].children.length, 1);
  });
  test('hierarchy helper computes hierarchy with empty input', () {
    var h = HierarchyHelper.computeHierarchy<TestModel>([]);
    expect(h, isNotNull);
    expect(h.length, 0);
    
  });
}
