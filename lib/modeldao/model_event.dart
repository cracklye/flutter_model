
 part of flutter_model; 


abstract class ModelsEvent<T extends IModel> {
  const ModelsEvent();
}

class ModelSelect<T extends IModel> extends ModelsEvent<T> {
  final T? model;
  final ModelStateMode mode;
  ModelSelect([this.model, this.mode = ModelStateMode.view]);
}

class LoadModels<T extends IModel> extends ModelsEvent<T> {
  final dynamic parentId;
  final dynamic id;
  const LoadModels({this.parentId, this.id});
}

class UpdateParameters<T extends IModel> extends ModelsEvent<T> {
  UpdateParameters(this.parameters);

  final Map<String, dynamic> parameters;
}

class RefreshLoadModel<T extends IModel> extends ModelsEvent<T> {
  const RefreshLoadModel();
}

class AddModel<T extends IModel> extends ModelsEvent<T> {
  final Map<String, dynamic> values;

  const AddModel(this.values);
}

class UpdateModel<T extends IModel> extends ModelsEvent<T> {
  final Map<String, dynamic> values;
  final dynamic id;

  const UpdateModel(this.id, this.values);
}

class UpdateSelected<T extends IModel> extends ModelsEvent<T> {
 
  const UpdateSelected();
}
class UpdateModelValue<T extends IModel> extends ModelsEvent<T> {
 final T model; 

  const UpdateModelValue(this.model);
}



class DeleteModel<T extends IModel> extends ModelsEvent<T> {
  final T model;

  const DeleteModel(this.model);
}


class CreateNewModel<T extends IModel> extends ModelsEvent<T> {
 
  const CreateNewModel();
}


class ModelsUpdated<T extends IModel> extends ModelsEvent<T> {
  final List<T> models;
  final String? id;

  const ModelsUpdated(this.models, [this.id]);
}

// abstract class ModelsEvent<T extends IModel> {
//   const ModelsEvent();
// }

// class ModelSelect<T extends IModel> extends ModelsEvent<T> {
//   final T? model;
//   final ModelStateMode mode;
//   ModelSelect([this.model, this.mode = ModelStateMode.view]);
// }

// class LoadModels<T extends IModel> extends ModelsEvent<T> {
//   final dynamic parentId;
//   final dynamic id;
//   const LoadModels({this.parentId, this.id});
// }

// class UpdateParameters<T extends IModel> extends ModelsEvent<T> {
//   UpdateParameters(this.parameters);

//   final Map<String, dynamic> parameters;
// }

// class RefreshLoadModel<T extends IModel> extends ModelsEvent<T> {
//   const RefreshLoadModel();
// }

// class AddModel<T extends IModel> extends ModelsEvent<T> {
//   final Map<String, dynamic> values;

//   const AddModel(this.values);
// }

// class UpdateModel<T extends IModel> extends ModelsEvent<T> {
//   final Map<String, dynamic> values;
//   final dynamic id;

//   const UpdateModel(this.id, this.values);
// }

// class UpdateSelected<T extends IModel> extends ModelsEvent<T> {
 
//   const UpdateSelected();
// }
// class UpdateModelValue<T extends IModel> extends ModelsEvent<T> {
//  final T model; 

//   const UpdateModelValue(this.model);
// }



// class DeleteModel<T extends IModel> extends ModelsEvent<T> {
//   final T model;

//   const DeleteModel(this.model);
// }


// class CreateNewModel<T extends IModel> extends ModelsEvent<T> {
 
//   const CreateNewModel();
// }


// class ModelsUpdated<T extends IModel> extends ModelsEvent<T> {
//   final List<T> models;
//   final String? id;

//   const ModelsUpdated(this.models, [this.id]);
// }
