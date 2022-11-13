part of flutter_model;

//part 'model_state.freezed.dart';

abstract class ModelsDetailState<T extends IModel> {
  ModelsDetailState({
    this.id,
  });

  final dynamic id;
}

class ModelsDetailError<T extends IModel> extends ModelsDetailState<T> {
  final String errorMessage;

  ModelsDetailError({
    super.id,
    required this.errorMessage,
  });

  factory ModelsDetailError.fromState(
      ModelsDetailState<T> state, String message,
      {id}) {
    return ModelsDetailError(
      id: id ?? state.id,
      errorMessage: message,
    );
  }
}

class ModelsDetailLoading<T extends IModel> extends ModelsDetailState<T> {
  ModelsDetailLoading({
    super.id,
  });

  factory ModelsDetailLoading.fromState(ModelsDetailState<T> state, {id}) {
    return ModelsDetailLoading(
      id: id ?? state.id,
    );
  }
}

class ModelsDetailLoaded<T extends IModel> extends ModelsDetailState<T> {
  final T model;

  ModelsDetailLoaded({
    required this.model,
    super.id,
  });

  ModelsDetailLoaded<T> copyWith({T? model, dynamic id, F}) {
    return ModelsDetailLoaded<T>(
      id: id ?? this.id,
      model: model ?? this.model,
    );
  }

  factory ModelsDetailLoaded.fromState(ModelsDetailState<T> state, T model) {
    return ModelsDetailLoaded(id: model.id, model: model);
  }

  @override
  String toString() {
    return "[ModelsLoaded \n    id:$id   ] ";
  }
}

class ModelsDetailNotLoaded<T extends IModel> extends ModelsDetailState<T> {
  ModelsDetailNotLoaded({
    super.id,
  });
  factory ModelsDetailNotLoaded.fromState(ModelsDetailState<T> state) {
    return ModelsDetailNotLoaded(id: state.id);
  }
}

class ModelDeleted<T extends IModel> extends ModelsDetailState<T> {
  ModelDeleted({
    super.id,
  });
  factory ModelDeleted.fromState(ModelsDetailState<T> state) {
    return ModelDeleted(id: state.id);
  }
}
