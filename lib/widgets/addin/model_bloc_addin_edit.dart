import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:loggy/loggy.dart';

abstract class ModelEditBlocAddin<T extends IModel> {
  /// This will build the provider required for editing.
  /// Providing an ID will select the document, providing null as the ID will try and create a new one.
  /// onSaved will be called when the model has been saved.
  Widget buildEditBlocProvider(BuildContext context,
      {dynamic id, dynamic parentId, Function(BuildContext context)? onSaved}) {
    AttachmentDAO? attachmentDao;
    try {
      attachmentDao = RepositoryProvider.of<AttachmentDAO>(context);
    } catch (e) {
      logWarning("Unable to create attachment", e);
    }
    return MultiBlocProvider(providers: [
      BlocProvider<ModelEditBloc<T>>(
        create: (context) {
          return ModelEditBloc<T>(
            RepositoryProvider.of<IModelAPI<T>>(context),
            attachmentDao,
          )..add(id == null
              ? ModelEditEventCreateNew(parentId)
              : ModelEditEventLoad(id));
        },
      ),
    ], child: buildEditBlocBuilder(context, onSaved));
  }

  Widget buildEditBlocBuilder(
      BuildContext context, Function(BuildContext context)? onSaved) {
    return BlocConsumer<ModelEditBloc<T>, ModelEditState<T>>(
        listener: (context, state) => {
              //TODO need to handle model saved....
              if (state is ModelEditStateSaved<T>)
                {
                  if (onSaved != null) {onSaved(context)}
                }
            },
        builder: (context, state) => buildEditBlocContent(context, state));
  }

  Widget buildEditBlocContent(BuildContext context, ModelEditState<T> state) {
    if (state is ModelEditStateSaving<T>) {
      return buildEditBlocSaving(context, state);
    } else if (state is ModelEditStateNotLoaded<T>) {
      return buildEditBlocNotLoaded(context, state);
    } else if (state is ModelEditStateLoaded<T>) {
      return buildEditBlocLoaded(context, state);
    } else if (state is ModelEditStateSaved<T>) {
      return buildEditBlocSaved(context, state);
    } else if (state is ModelEditStateError<T>) {
      return buildEditBlocError(context, state);
    }
    return Text("Unknown state $state");
  }

  Widget buildEditBlocLoaded(
      BuildContext context, ModelEditStateLoaded<T> state) {
    return Container();
  }

  Widget buildEditBlocSaving(
      context, ModelEditStateSaving<T> modelEditStateSaving) {
    return Container();
  }

  Widget buildEditBlocNotLoaded(context, ModelEditStateNotLoaded<T> state) {
    return Container();
  }

  Widget buildEditBlocSaved(context, ModelEditStateSaved<T> state) {
    return Container();
  }

  Widget buildEditBlocError(context, ModelEditStateError<T> state) {
    return Container();
  }

  T modelFromParams(Map<String, dynamic> params) {
    throw UnimplementedError(
        "NOt implemented the model from params but passed in params");
  }
}
