part of flutter_model;

//part 'model_state.freezed.dart';

abstract class ModelsState<T extends IModel> {}

class ModelsLoading<T extends IModel> extends ModelsState<T> {
  ModelsLoading();
}

enum ModelStateMode { view, edit }

class ModelsLoaded<T extends IModel> with ModelsState<T> {
  //@Default(ModelStateMode.view)
  final ModelStateMode mode;
  final List<T> models;
  final String? id;
  final T? selected;
  final Map<String, dynamic>? parameters;

  ModelsLoaded({
    this.mode = ModelStateMode.view,
    this.models = const [],
    this.id,
    this.selected,
    this.parameters,
  });

  ModelsLoaded<T> copyWith({
    ModelStateMode? mode,
    List<T>? models,
    String? id,
    T? selected,
    Map<String, dynamic>? parameters,
  }) {
    return ModelsLoaded<T>(
        id: id ?? this.id,
        mode: mode ?? this.mode,
        models: models ?? this.models,
        selected: selected ?? this.selected,
        parameters: parameters ?? this.parameters);
  }

  // const ModelsLoaded(
  //     [this.models = const [],
  //     this.parentId,
  //     this.id,
  //     this.parameters,
  //     this.selected]);
@override
  String toString(){
return "[ModelsLoaded \n id:$id \n selected: $selected \n mode: $mode \n models:$models \n parameters: $parameters";
  }
}

class ModelsNotLoaded<T extends IModel> extends ModelsState<T> {}


// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:imageffi/model/persist/imodel.dart';
//   part 'model_state.freezed.dart';


// abstract class ModelsState<T extends IModel> {
  
// }

// class ModelsLoading<T extends IModel> extends ModelsState<T> {
//    ModelsLoading();
// }

// enum ModelStateMode {view, edit}

// @Freezed()
// class ModelsLoaded<T extends IModel> with _$ModelsLoaded<T>, ModelsState<T> {
//   factory ModelsLoaded({
    
    
//     @Default(ModelStateMode.view) ModelStateMode mode , 

//     @Default([]) List<T> models,
    
//     String? id,
//     T? selected,
//     Map<String, dynamic>? parameters,

//   }) = _ModelsLoaded;

//   // const ModelsLoaded(
//   //     [this.models = const [],
//   //     this.parentId,
//   //     this.id,
//   //     this.parameters,
//   //     this.selected]);
// }

// class ModelsNotLoaded<T extends IModel> extends ModelsState<T> {}
