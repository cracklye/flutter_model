// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_model/flutter_model.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';

// import '../../mocks/model_api_mock.mocks.dart';
// import '../../mocks/test_model.dart';
//TODO need to fix the errors
// void main() {
//   group('ModelEditBloc', () {
//     group('Constructor', () {
//       blocTest<ModelEditBloc<TestModel>, ModelEditState<TestModel>>(
//           'emits [] and inits state to ModelsDetailNotLoaded when initialised with default state',
//           build: () => ModelEditBloc<TestModel>(
//                 MockIModelAPI(),
//               ),
//           expect: () => [],
//           verify: ((bloc) =>
//               expect(bloc.state, isA<ModelEditStateNotLoaded<TestModel>>())));

//       blocTest<ModelEditBloc<TestModel>, ModelEditState<TestModel>>(
//           'emits [] and inits state to ModelEditStateEdit when providing a default state',
//           build: () => ModelEditBloc<TestModel>(
//               MockIModelAPI(), const ModelEditStateChanged<TestModel>()),
//           expect: () => [],
//           verify: ((bloc) =>
//               expect(bloc.state, isA<ModelEditStateChanged<TestModel>>())));
//     });

//     group('event - ModelEditEventMode', () {
//       blocTest<ModelEditBloc<TestModel>, ModelEditState<TestModel>>(
//         'emits [ModelEditStateEdit] when editMode is true',
//         build: () => ModelEditBloc<TestModel>(MockIModelAPI()),

//         act: (bloc) {
//           bloc.add(const ModelEditEventMode(true));
//         },

//         expect: () => [isA<ModelEditStateEdit<TestModel>>()],
//         // verify: ((bloc) =>
//         //     expect(bloc.state, isA<ModelsListLoading<TestModel>>()))
//       );

//       blocTest<ModelEditBloc<TestModel>, ModelEditState<TestModel>>(
//         'emits [ModelEditStateView] when editMode is false',
//         build: () => ModelEditBloc<TestModel>(MockIModelAPI()),
//         act: (bloc) {
//           bloc.add(const ModelEditEventMode(false));
//         },
//         expect: () => [isA<ModelEditStateView<TestModel>>()],
//         // verify: ((bloc) =>
//         //     expect(bloc.state, isA<ModelsListLoading<TestModel>>()))
//       );
//     });
//     group('event - ModelEditEventChanged', () {
//       blocTest<ModelEditBloc<TestModel>, ModelEditState<TestModel>>(
//         'emits [ModelEditStateEdit] when raised ModelEditEventChanged',
//         build: () => ModelEditBloc<TestModel>(MockIModelAPI()),

//         act: (bloc) {
//           bloc.add(const ModelEditEventChanged());
//         },

//         expect: () => [isA<ModelEditStateChanged<TestModel>>()],
//         // verify: ((bloc) =>
//         //     expect(bloc.state, isA<ModelsListLoading<TestModel>>()))
//       );
//     });

//     group('event - ModelEditEventDelete', () {
//       blocTest<ModelEditBloc<TestModel>, ModelEditState<TestModel>>(
//           'emits [ModelEditStateEdit] when raised ModelEditEventDelete',
//           build: () => ModelEditBloc<TestModel>(MockIModelAPI(),
//               ModelEditStateView<TestModel>(TestModel(name: "name", id: "25"))),
//           act: (bloc) {
//             bloc.add(const ModelEditEventDelete());
//           },
//           expect: () => [isA<ModelEditStateNotLoaded<TestModel>>()],
//           verify: ((bloc) => verify(bloc.dao.deleteById("25")).called(1)
//               //     expect(bloc.state, isA<ModelsListLoading<TestModel>>()))
//               ));
//     });

//     group('event - ModelEditEventCreateNew', () {
//       blocTest<ModelEditBloc<TestModel>, ModelEditState<TestModel>>(
//         'emits [ModelEditStateEdit] when raised ModelEditEventCreateNew',
//         build: () => ModelEditBloc<TestModel>(MockIModelAPI()),
//         act: (bloc) {
//           bloc.add(const ModelEditEventCreateNew());
//         },
//         expect: () => [
//           isA<ModelEditStateEdit<TestModel>>()
//               .having((p0) => p0.model, "model is null", isNull)
//         ],
//         //verify: ((bloc) => verify(bloc.dao.deleteById("25")).called(1)

//         //     expect(bloc.state, isA<ModelsListLoading<TestModel>>()))
//         //)
//       );
//     });

//     group('event - ModelEditEventSave', () {
//       blocTest<ModelEditBloc<TestModel>, ModelEditState<TestModel>>(
//         'emits [ModelEditStateEdit] saved new model',
//         build: () => ModelEditBloc<TestModel>(MockIModelAPI()),
//         act: (bloc) {
//           bloc.add(const ModelEditEventSave({}));
//         },
//         expect: () => [
//           isA<ModelEditStateSaving<TestModel>>(),
//           isA<ModelEditStateEdit<TestModel>>(),
//         ],
//         verify: (bloc) => verify(bloc.dao.create({})).called(1),
//       );

//       TestModel testModel = TestModel(name: "test", id: "1234");

//       blocTest<ModelEditBloc<TestModel>, ModelEditState<TestModel>>(
//         'emits [ModelEditStateEdit] saved existing model',
//         build: () => ModelEditBloc<TestModel>(
//             MockIModelAPI(), ModelEditStateEdit(testModel)),
//         act: (bloc) {
//           bloc.add(const ModelEditEventSave({}));
//         },
//         expect: () => [
//           isA<ModelEditStateSaving<TestModel>>(),
//           isA<ModelEditStateEdit<TestModel>>(),
//         ],
//         verify: (bloc) => verify(bloc.dao.update(testModel.id, {})).called(1),
//       );

//       blocTest<ModelEditBloc<TestModel>, ModelEditState<TestModel>>(
//         'emits [ModelEditStateEdit] saved existing model, edit = true emits additional state change',
//         build: () => ModelEditBloc<TestModel>(
//             MockIModelAPI(), ModelEditStateEdit(testModel)),
//         act: (bloc) {
//           bloc.add(const ModelEditEventSave({}, true));
//         },
//         expect: () => [
//           isA<ModelEditStateSaving<TestModel>>(),
//           isA<ModelEditStateEdit<TestModel>>(),
//           isA<ModelEditStateEdit<TestModel>>(),
//         ],
//         verify: (bloc) => verify(bloc.dao.update(testModel.id, {})).called(1),
//       );

//        blocTest<ModelEditBloc<TestModel>, ModelEditState<TestModel>>(
//         'emits [ModelEditStateEdit] saved existing model, edit = false emits additional state change',
//         build: () => ModelEditBloc<TestModel>(
//             MockIModelAPI(), ModelEditStateEdit(testModel)),
//         act: (bloc) {
//           bloc.add(const ModelEditEventSave({}, false));
//         },
//         expect: () => [
//           isA<ModelEditStateSaving<TestModel>>(),
//           isA<ModelEditStateEdit<TestModel>>(),
//           isA<ModelEditStateView<TestModel>>(),
//         ],
//         verify: (bloc) => verify(bloc.dao.update(testModel.id, {})).called(1),
//       );


//     });


//      group('event - ModelEditEventSelect', () {
//        TestModel testModel = TestModel(name: "test", id: "1234");

//       blocTest<ModelEditBloc<TestModel>, ModelEditState<TestModel>>(
//         'emits [ModelEditStateEdit] null model when raised ModelEditEventSelect',
//         build: () => ModelEditBloc<TestModel>(MockIModelAPI()),
//         act: (bloc) {
//           bloc.add( const ModelEditEventSelect(null,true));
//         },
//         expect: () => [
//           isA<ModelEditStateEdit<TestModel>>()
//               .having((p0) => p0.model, "model is null", isNull)
//         ],
//       );

//       blocTest<ModelEditBloc<TestModel>, ModelEditState<TestModel>>(
//         'emits [ModelEditStateEdit] not null model when raised ModelEditEventSelect',
//         build: () => ModelEditBloc<TestModel>(MockIModelAPI()),
//         act: (bloc) {
//           bloc.add(  ModelEditEventSelect(testModel,true));
//         },
//         expect: () => [
//           isA<ModelEditStateEdit<TestModel>>()
//               .having((p0) => p0.model, "model is not null", isNotNull)
//         ],
//       );

//       blocTest<ModelEditBloc<TestModel>, ModelEditState<TestModel>>(
//         'emits [ModelEditStateView] not null model when raised ModelEditEventSelect',
//         build: () => ModelEditBloc<TestModel>(MockIModelAPI()),
//         act: (bloc) {
//           bloc.add(  ModelEditEventSelect(testModel,false));
//         },
//         expect: () => [
//           isA<ModelEditStateView<TestModel>>()
//               .having((p0) => p0.model, "model is not null", isNotNull)
//         ],
//       );

//     });



//   });
// }
