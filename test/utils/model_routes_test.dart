import 'package:flutter_model/flutter_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/test_model.dart';

void main() {
  test('mapFromParams', () {
    // expect("testmodel", mapFromParams<TestModel>());
  });

  group("routeEdit", () {
    test('returns values as expected ', () {
      // expect("testmodel", mapFromParams<TestModel>());
      expect(ModelRouter.routeEdit<TestModel>("255"), "/testmodel/edit/255");
      expect(ModelRouter.routeEdit<TestModel>(null), "/testmodel/edit/null");
      expect(ModelRouter.routeEdit<TestModel>("255", "123"),
          "/testmodel/edit/255/123");
      expect(ModelRouter.routeEdit<TestModel>(255, 123),
          "/testmodel/edit/255/123");
    });
  });

  group("routeDetail", () {
    test('returns values as expected ', () {
      // expect("testmodel", mapFromParams<TestModel>());
      expect(
          ModelRouter.routeDetail<TestModel>("255"), "/testmodel/detail/255");
      expect(
          ModelRouter.routeDetail<TestModel>(null), "/testmodel/detail/null");
      expect(ModelRouter.routeDetail<TestModel>("255", "123"),
          "/testmodel/detail/255/123");

      expect(ModelRouter.routeDetail<TestModel>(255, 123),
          "/testmodel/detail/255/123");
    });
  });

  group("create", () {
    test('returns values as expected ', () {
      // expect("testmodel", mapFromParams<TestModel>());
      expect(ModelRouter.routeAdd<TestModel>("255"), "/testmodel/create/255");
      expect(ModelRouter.routeAdd<TestModel>(255), "/testmodel/create/255");
      expect(ModelRouter.routeAdd<TestModel>(null), "/testmodel/create");
    });
  });

  group("routeList", () {
    test('returns values as expected ', () {
      // expect("testmodel", mapFromParams<TestModel>());
      expect(ModelRouter.routeList<TestModel>(), "/testmodel/list");
    });
  });

  group("routeEditByTypeName", () {
    test('returns values as expected ', () {
      // expect("testmodel", mapFromParams<TestModel>());
      expect(ModelRouter.routeEditByTypeName("TestType", "123"),
          "/testtype/edit/123");
      expect(ModelRouter.routeEditByTypeName("TestType", "123", "456"),
          "/testtype/edit/123/456");
      expect(ModelRouter.routeEditByTypeName("TestType", 123, 456),
          "/testtype/edit/123/456");
    });
  });

  group("routeDetailByTypeName", () {
    test('returns values as expected ', () {
      // expect("testmodel", mapFromParams<TestModel>());
      expect(ModelRouter.routeDetailByTypeName("TestType", "123"),
          "/testtype/detail/123");
      expect(ModelRouter.routeDetailByTypeName("TestType", "123", "456"),
          "/testtype/detail/123/456");

      expect(ModelRouter.routeDetailByTypeName("TestType", 123, 456),
          "/testtype/detail/123/456");
    });
  });

  group("routeAddByTypeName", () {
    test('returns values as expected ', () {
      // expect("testmodel", mapFromParams<TestModel>());
      expect(ModelRouter.routeAddByTypeName("TestType", "123"),
          "/testtype/create/123");
      expect(ModelRouter.routeAddByTypeName("TestType"), "/testtype/create");

      expect(ModelRouter.routeAddByTypeName("TestType", 123),
          "/testtype/create/123");
    });
  });

   group("routeListByTypeName", () {
    test('returns values as expected ', () {
      // expect("testmodel", mapFromParams<TestModel>());
      expect(ModelRouter.routeListByTypeName("TestType"),
          "/testtype/list");
     
    });
  });
}
