import 'package:mockito/annotations.dart';
import 'package:flutter_model/flutter_model.dart';



@GenerateNiceMocks([MockSpec<IModel>(), MockSpec<IModelAPI<TestModel>>()])
//import 'model_api_mock.mocks.dart';

import 'test_model.dart';

//need to check the versions of the dependencies as it looks like the 
//flutter pub run build_runner build --delete-conflicting-outputs
//isn't working