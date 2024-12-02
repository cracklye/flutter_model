import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_events.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_state.dart';
import 'package:flutter_model/bloc/modeledit/model_edit_view2.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:loggy/loggy.dart';

mixin class ModelEditViewBlocAddin<T extends IModel> {
  /// This will build the provider required for editing.
  /// Providing an ID will select the document, providing null as the ID will try and create a new one.
  /// onSaved will be called when the model has been saved.
  Widget buildEditViewBlocProvider(BuildContext context,
      {dynamic id, dynamic parentId, Function(BuildContext context)? onSaved}) {
    AttachmentDAO? attachmentDao;
    try {
      attachmentDao = RepositoryProvider.of<AttachmentDAO>(context);
    } catch (e) {
      logWarning("Unable to create attachment", e);
    }
    return MultiBlocProvider(providers: [
      BlocProvider<ModelEditViewBloc<T>>(
        create: (context) {
          return ModelEditViewBloc<T>(
            RepositoryProvider.of<IModelAPI<T>>(context),
            attachmentDao,
          )..add(id == null
              ? ModelEditViewEventCreateNew(parentId)
              : ModelEditViewEventSelect(id, false));
        },
      ),
    ], child: buildEditViewBlocBuilder(context, onSaved));
  }

  Widget buildEditViewBlocBuilder(
      BuildContext context, Function(BuildContext context)? onSaved) {
    return BlocConsumer<ModelEditViewBloc<T>, ModelEditViewState<T>>(
        listener: (context, state) => {
              //TODO need to handle model saved....
              if (state.isSaved)
                {
                  if (onSaved != null) {onSaved(context)}
                }
            },
        builder: (context, state) => buildEditViewBlocContent(context, state));
  }

  Widget buildEditViewBlocContent(
      BuildContext context, ModelEditViewState<T> state) {
    if (state is ModelEditViewStateLoading<T>) {
      return buildEditViewBlocLoading(context, state);
    } else if (state is ModelEditViewStateNotLoaded<T>) {
      return buildEditViewBlocNotLoaded(context, state);
    } else if (state is ModelEditViewStateLoaded<T>) {
      return buildEditViewBlocLoaded(context, state);
    }
    return Text("Unknown state $state");
  }

  Widget buildEditViewBlocLoading(
      BuildContext context, ModelEditViewStateLoading<T> state) {
    return Container();
  }

  Widget buildEditViewBlocLoaded(
      BuildContext context, ModelEditViewStateLoaded<T> state) {
    return Container();
  }

  Widget buildEditViewBlocNotLoaded(
      context, ModelEditViewStateNotLoaded<T> state) {
    return Container();
  }

  T modelFromParams(Map<String, dynamic> params) {
    throw UnimplementedError(
        "NOt implemented the model from params but passed in params");
  }
}
