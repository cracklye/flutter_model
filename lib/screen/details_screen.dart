import 'package:flutter/material.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:flutter_model/widgets/addin/model_bloc_addin_detail.dart';

class ModelScreenDetail<T extends IModel> extends StatelessWidget
    with ModelDetailBlocAddin<T> {
  final dynamic id;
  final Function(BuildContext context)? onDeleted;

  ModelScreenDetail({
    required this.id,
    this.onDeleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return buildDetailBlocProvider(context, id, onDeleted);
  }

  @override
  Widget buildDetailBlocContent(
      BuildContext context, ModelsDetailState<T> state) {
    return Scaffold(
      body: super.buildDetailBlocContent(context, state),
      appBar: AppBar(
        centerTitle: true,
        title: Text((state is ModelsDetailLoaded<T>)
            ? state.model.displayLabel
            : "Loading"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () {
              Navigator.of(context).pushNamed(ModelRouter.routeEdit<T>(
                  (state as ModelsDetailLoaded<T>).model.id));
            },
          ),
          IconButton(
            icon: const Icon(Icons.deblur),
            tooltip: 'Delete',
            onPressed: () {
              doDelete(context, (state as ModelsDetailLoaded<T>).model);
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Close',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
