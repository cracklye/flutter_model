import 'package:flutter_model/flutter_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/test_model.dart';

void main() {
  test('getModelKeyFromType works as expected', () {
    expect("testmodel", getModelKeyFromType<TestModel>());
    expect("imodel", getModelKeyFromType());
  });
}
