import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/model_api_mock.mocks.dart';
import '../../mocks/test_model.dart';

void main() {
  group('ModelsDetailBloc', () {
    group('Constructor', () {
      blocTest<ModelsDetailBloc<TestModel>, ModelsDetailState<TestModel>>(
          'emits [] and inits state to ModelsDetailNotLoaded when initialised with default state',
          build: () =>
              ModelsDetailBloc<TestModel>(modelsRepository: MockIModelAPI()),
          expect: () => [],
          verify: ((bloc) =>
              expect(bloc.state, isA<ModelsDetailNotLoaded<TestModel>>())));

      blocTest<ModelsDetailBloc<TestModel>, ModelsDetailState<TestModel>>(
          'emits [] and inits state to ModelsDetailLoading when passed into initialState',
          build: () => ModelsDetailBloc<TestModel>(
              modelsRepository: MockIModelAPI(),
              initialState: ModelsDetailLoading<TestModel>()),
          expect: () => [],
          verify: ((bloc) =>
              expect(bloc.state, isA<ModelsDetailLoading<TestModel>>())));
    });

    group('Event - ModelsDetailLoad ', () {
      blocTest<ModelsDetailBloc<TestModel>, ModelsDetailState<TestModel>>(
        'throws error when null id passed in',
        build: () =>
            ModelsDetailBloc<TestModel>(modelsRepository: MockIModelAPI()),
        act: (bloc) {
          bloc.add(const ModelsDetailLoad(id: null));
        },
        expect: () => [isA<ModelsDetailError<TestModel>>()],
      );

      blocTest<ModelsDetailBloc<TestModel>, ModelsDetailState<TestModel>>(
          'successful load raised state',
          build: () =>
              ModelsDetailBloc<TestModel>(modelsRepository: MockIModelAPI()),
          act: (bloc) {
            bloc.add(const ModelsDetailLoad(id: "25"));
          },
          expect: () => [
                isA<ModelsDetailLoading<TestModel>>()
                    .having((p0) => p0.id, "id is 25", "25")
              ],
          verify: ((bloc) =>
              verify(bloc.modelsRepository.listById("25")).called(1)));

      blocTest<ModelsDetailBloc<TestModel>, ModelsDetailState<TestModel>>(
        'throws error when null retirned from list',
        build: () =>
            ModelsDetailBloc<TestModel>(modelsRepository: MockIModelAPI()),
        act: (bloc) {
          when(bloc.modelsRepository.listById("30"))
              .thenAnswer((_) async => Stream.fromIterable([null]));
          bloc.add(const ModelsDetailLoad(id: "30"));
        },
        expect: () => [
          isA<ModelsDetailLoading<TestModel>>()
              .having((p0) => p0.id, "id is 30", "30"),
          isA<ModelsDetailError<TestModel>>()
        ],
      );
      blocTest<ModelsDetailBloc<TestModel>, ModelsDetailState<TestModel>>(
        'returns mdoel when successful',
        build: () =>
            ModelsDetailBloc<TestModel>(modelsRepository: MockIModelAPI()),
        act: (bloc) {
          when(bloc.modelsRepository.listById("30")).thenAnswer(
              (_) async => Stream.fromIterable([TestModel(name: "name")]));
          bloc.add(const ModelsDetailLoad(id: "30"));
        },
        expect: () => [
          isA<ModelsDetailLoading<TestModel>>()
              .having((p0) => p0.id, "id is 30", "30"),
          isA<ModelsDetailLoaded<TestModel>>()
        ],
      );
    });

    group('Event - ModelDetailRaiseError ', () {
      blocTest<ModelsDetailBloc<TestModel>, ModelsDetailState<TestModel>>(
        'returns error state',
        build: () =>
            ModelsDetailBloc<TestModel>(modelsRepository: MockIModelAPI()),
        act: (bloc) {
          bloc.add(const ModelDetailRaiseError("error message"));
        },
        expect: () => [
          isA<ModelsDetailError<TestModel>>().having(
              (p0) => p0.errorMessage, "error message is set ", "error message")
        ],
      );
    });

    group('Event - ModelsDetailDelete ', () {
      blocTest<ModelsDetailBloc<TestModel>, ModelsDetailState<TestModel>>(
          'returns deleted model when successful',
          build: () =>
              ModelsDetailBloc<TestModel>(modelsRepository: MockIModelAPI()),
          act: (bloc) {
            bloc.add(const ModelsDetailDelete("27"));
          },
          expect: () => [
                isA<ModelDeleted<TestModel>>()
                    .having((p0) => p0.id, "id is 27 ", "27")
              ],
          verify: ((bloc) =>
              verify(bloc.modelsRepository.deleteById("27")).called(1)));

      blocTest<ModelsDetailBloc<TestModel>, ModelsDetailState<TestModel>>(
          'returns error when id passed in is null',
          build: () =>
              ModelsDetailBloc<TestModel>(modelsRepository: MockIModelAPI()),
          act: (bloc) {
            bloc.add(const ModelsDetailDelete(null));
          },
          expect: () => [isA<ModelsDetailError<TestModel>>()],
          verify: ((bloc) =>
              verifyNever(bloc.modelsRepository.deleteById(any))));
    });

    group('Event - ModelsDetailUpdateDetail ', () {
      blocTest<ModelsDetailBloc<TestModel>, ModelsDetailState<TestModel>>(
        'returns error state',
        build: () =>
            ModelsDetailBloc<TestModel>(modelsRepository: MockIModelAPI()),
        act: (bloc) {
          bloc.add(ModelsDetailUpdateDetail(TestModel(
            name: "model1",
            id: "1234",
          )));
        },
        expect: () => [
          isA<ModelsDetailLoaded<TestModel>>()
              .having((p0) => p0.id, "id is 1234 ", "1234")
              .having((p0) => p0.model, "model is not null ", isNotNull)
        ],
      );
    });
  });
}
