part of flutter_model;

class ModelListSearchBox<T extends IModel> extends StatefulWidget {
  const ModelListSearchBox(
      {super.key, this.enableSearch = true, this.defaultSearchText = ""});
  final bool enableSearch;
  final String defaultSearchText;

  @override
  State<ModelListSearchBox<T>> createState() => _ModelListSearchBoxState<T>();
}

class _ModelListSearchBoxState<T extends IModel>
    extends State<ModelListSearchBox<T>> {
  @override
  void initState() {
    _searchController = TextEditingController();
    _searchController.text = (widget.defaultSearchText );

    super.initState();
  }

  late TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    if (widget.enableSearch) {
      return BlocBuilder<ModelsListBloc<T>, ModelsListState<T>>(
          builder: (context, shotState) {
        return Row(
          children: [
            const Icon(FontAwesomeIcons.magnifyingGlass),
            Expanded(
                //TODO need to remove material
                child: m.Material(
                    child: m.TextFormField(
              controller: _searchController,
              onChanged: (value) {
                BlocProvider.of<ModelsListBloc<T>>(context)
                    .add(ModelsListChangeSearchText<T>(value));
              },
            ))),
            IconButton(
                onPressed: (() => BlocProvider.of<ModelsListBloc<T>>(context)
                    .add(ModelsListChangeSearchText<T>(""))),
                icon: const Icon(FontAwesomeIcons.xmark)),
          ],
        );
      });
    }
    return Container();
  }
}
