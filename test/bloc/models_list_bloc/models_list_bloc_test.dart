import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loggy/loggy.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/model_api_mock.mocks.dart';
import '../../mocks/test_model.dart';

//https://pub.dev/packages/bloc_test
//https://pub.dev/packages/mockito

// @GenerateNiceMocks([MockSpec<Database>(), MockSpec<DatabaseConfiguration>()])
// import 'database_bloc_test.mocks.dart';

var testModel = TestModel(id: "1", name: "test 1");
var testModels = [
  testModel,
  TestModel(id: "2", name: "test 2"),
  TestModel(id: "3", name: "test 3")
];
void main() {
  setUp(() {
    // Loggy.initLoggy(
    //   logPrinter: const PrettyPrinter(),
    // );
  });

  group('ModelsListBloc', () {
    group('Constructor', () {
      blocTest<ModelsListBloc<TestModel>, ModelsListState<TestModel>>(
          'emits [] and inits state to ModelsDetailNotLoaded when initialised with default state',
          build: () =>
              ModelsListBloc<TestModel>(modelsRepository: MockIModelAPI()),
          expect: () => [],
          verify: ((bloc) =>
              expect(bloc.state, isA<ModelsListLoading<TestModel>>())));
    });

    group('event - ModelsListLoad', () {
      blocTest<ModelsListBloc<TestModel>, ModelsListState<TestModel>>(
          'emits [] and inits state to ModelsDetailNotLoaded when initialised with default state',
          build: () =>
              ModelsListBloc<TestModel>(modelsRepository: MockIModelAPI()),
          act: (bloc) {
            bloc.add(const ModelsListLoad(parentId: "1234"));
          },
          expect: () => [isA<ModelsListLoading<TestModel>>()],
          verify: ((bloc) =>
              expect(bloc.state, isA<ModelsListLoading<TestModel>>())));

      blocTest<ModelsListBloc<TestModel>, ModelsListState<TestModel>>(
        'clear is true, returns empty ',
        build: () =>
            ModelsListBloc<TestModel>(modelsRepository: MockIModelAPI()),
        act: (bloc) {
          bloc.add(const ModelsListLoad(parentId: "1234", clear: true));
        },
        expect: () => [
          isA<ModelsListLoading<TestModel>>(),
          isA<ModelsListLoading<TestModel>>(),
          isA<ModelsListLoaded<TestModel>>()
          // .having((p0) => p0.models, 'models are empty', [])
        ],
        // verify: ((bloc) =>
        //     expect(bloc.state, isA<ModelsListLoading<TestModel>>()))
      );

      blocTest<ModelsListBloc<TestModel>, ModelsListState<TestModel>>(
        'returns list as expected',
        build: () =>
            ModelsListBloc<TestModel>(modelsRepository: MockIModelAPI()),
        act: (bloc) {
          when(bloc.modelsRepository.list(parentId: "1234"))
              .thenAnswer((_) async => Stream.value(testModels));

          bloc.add(const ModelsListLoad(
            parentId: "1234",
          ));
        },
        expect: () => [
          isA<ModelsListLoading<TestModel>>(),
          isA<ModelsListLoading<TestModel>>(),
          isA<ModelsListLoaded<TestModel>>()
          .having((p0) => p0.models.length, 'models count is 3', 3)
        ],
        verify: (bloc) =>
            {verify(bloc.modelsRepository.list(parentId: "1234")).called(1)},
        // verify: ((bloc) =>
        //     expect(bloc.state, isA<ModelsListLoading<TestModel>>()))
      );
    });
  });
}
