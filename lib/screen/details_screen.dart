import 'package:flutter/widgets.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:flutter_model/widgets/addin/model_bloc_addin_detail.dart';

import 'package:flutter/material.dart';

class ModelScreenDetail<T extends IModel> extends StatelessWidget
    with ModelDetailBlocAddin<T> {
  final dynamic id;
  final Function(BuildContext context)? onDeleted;

  ModelScreenDetail({
    required this.id,
    this.onDeleted,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildDetailBlocProvider(context, id, onDeleted);
  }

  @override
  Widget buildDetailBlocContent(
      BuildContext context, ModelsDetailState<T> state) {
    return Scaffold(
      appBar: AppBar(
        title: isDetailLoaded(state)
            ? Text(
                (state as ModelsDetailLoaded<T>).model.displayLabel,
                overflow: TextOverflow.ellipsis,
              )
            : const Text("View"),
        actions: (state is ModelsDetailLoaded)
            ? [
                ElevatedButton(
                  child: const Text("Edit"),
                  onPressed: () => Navigator.of(context).pushNamed(
                      ModelRouter.routeEdit<T>(
                          (state as ModelsDetailLoaded<T>).model.id)),
                ),
                ElevatedButton(
                  child: const Text("Delete"),
                  onPressed: () =>
                      doDelete(context, (state as ModelsDetailLoaded<T>).model),
                ),
              ]
            : [],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: super.buildDetailBlocContent(context, state)),
    );
  }
}
