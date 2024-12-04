
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';


mixin ModelListBlocAddin<T extends IModel> {
  Widget buildListBlocProvider(BuildContext context, dynamic parentId) {
    return BlocProvider<ModelsBloc<T>>(
        create: ((context) => ModelsBloc<T>(
            modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context))
          ..add(ModelsLoad<T>(
            parentId: parentId,
          ))),
        child: buildListBlocBuilder(context));
  }

  Widget buildListBlocBuilder(BuildContext context) {
    return BlocBuilder<ModelsBloc<T>, ModelsState<T>>(
      builder: (context, state) {
        //  return buildBlocLoaded(context, state);
        return buildListBlocContent(context, state);
      },
    );
  }

  Widget buildListBlocContent(BuildContext context, ModelsState<T> state) {
    if (state is ModelsLoaded<T>) {
      return buildListBlocLoaded(context, state);
    } else if (state is ModelsLoading<T>) {
      return buildListBlocLoading(context, state);
    }
    if (state is ModelsNotLoaded<T>) {
      return buildListBlocNotLoaded(context, state);
    }
    return Text("Unknown state: $state");
  }

  Widget buildListBlocLoaded(BuildContext context, ModelsLoaded<T> state) {
    return Container();
  }

  Widget buildListBlocLoading(
      BuildContext context, ModelsLoading<T> state) {
    return const Text("Loading");
  }

  Widget buildListBlocNotLoaded(
      BuildContext context, ModelsNotLoaded<T> state) {
    return const Text("Not Loaded");
  }

  void doListChangeSearch(BuildContext context, String searchString) {
    BlocProvider.of<ModelsBloc<T>>(context)
        .add(ModelsChangeSearchText<T>(searchString));
  }

  // void doListChangeOrderBy(
  //     BuildContext context, SortOrderBy? orderByChange) {
  //   BlocProvider.of<ModelsBloc<T>>(context).add(ModelsChangeOrderBy<T>(
  //       orderByChange != null ? orderByChange!.getSortOrders() : null));
  // }

  // void doListChangeFilter(BuildContext context, FilterByItem<T>? filter) {
  //   BlocProvider.of<ModelsBloc<T>>(context).add(
  //       ModelsChangeFilter<T>(filter != null ? filter.getFilters() : null));
  // }

  bool isListLoaded(ModelsState<T> state) {
    if (state is ModelsLoaded<T>) {
      return true;
    }
    return false;
  }

  bool isListLoading(ModelsState<T> state) {
    if (state is ModelsLoading<T>) {
      return true;
    }
    return false;
  }
}
