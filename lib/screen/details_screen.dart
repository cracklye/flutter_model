part of flutter_model;

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
    return m.Scaffold(
      appBar: m.AppBar(
        title: isDetailLoaded(state)
            ? Text(
                (state as ModelsDetailLoaded<T>).model.displayLabel,
                overflow: TextOverflow.ellipsis,
              )
            : Text("View"),
        actions: (state is ModelsDetailLoaded)
            ? [
                ElevatedButton(
                  child: Text("Edit"),
                  onPressed: () => Navigator.of(context).pushNamed(
                      ModelRouter.routeEdit(
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
      body: super.buildDetailBlocContent(context, state),
    );
  }
}
