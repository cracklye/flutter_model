import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';

enum BlocMode { consumer, provider, none }

abstract class ModelWidgetStateless<T extends IModel> extends StatelessWidget {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final dynamic parentId;
  final dynamic id;
  final BlocMode blocMode;
  final ModelDialog<T>? modelDialog;
  final LaunchType launchTypeEdit;
  final LaunchType launchTypeDetail;
  final LaunchType launchTypeAdd;
  final List<OrderByListOption>? orderBy;

  ModelWidgetStateless({
    this.id,
    this.parentId,
    this.blocMode = BlocMode.consumer,
    this.modelDialog,
    this.orderBy,
    key,
    this.launchTypeEdit = LaunchType.navigate,
    this.launchTypeDetail = LaunchType.navigate,
    this.launchTypeAdd = LaunchType.navigate,
  }) : super(key: key) {}

  Widget buildContent(BuildContext context);

  void navigateToEdit(BuildContext context, T model) {
    // print("navigateToEdit($model, $parentId)");
    Navigator.of(context).pushNamed(ModelKeys.routeEdit<T>(model.id, parentId));
  }

  void navigateToDetails(BuildContext context, T model) {
    Navigator.of(context)
        .pushNamed(ModelKeys.routeDetail<T>(model.id, parentId));
  }

  void navigateToNew(BuildContext context) {
    Navigator.of(context).pushNamed(ModelKeys.routeAdd<T>(parentId));
  }

  void dialogEdit(BuildContext context, T model) {
    modelDialog!.showAdd(context, formKey, model, parentId);
  }

  void dialogToDetails(BuildContext context, T model) {
    modelDialog!.showDetail(context, model, formKey, (context, key, model) {
      doEdit(context, model);
    });
  }

  void dialogToNew(BuildContext context) {
    modelDialog!.showAdd(context, formKey, null, parentId);
  }

  void doEdit(BuildContext context, T model) {
    if (launchTypeEdit == LaunchType.navigate) {
      navigateToEdit(context, model);
    } else if (launchTypeEdit == LaunchType.dialog) {
      dialogEdit(context, model);
    } else {}
  }

  void doDetails(BuildContext context, T model) {
    if (launchTypeDetail == LaunchType.navigate) {
      navigateToDetails(context, model);
    } else if (launchTypeDetail == LaunchType.dialog) {
      dialogToDetails(context, model);
    } else {}
  }

  void doAdd(BuildContext context) {
    if (launchTypeAdd == LaunchType.navigate) {
      navigateToNew(context);
    } else if (launchTypeAdd == LaunchType.dialog) {
      dialogToNew(context);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    if (blocMode == BlocMode.provider) {
      return buildBlocProvider(context);
    } else {
      return buildBlocBuilder(context);
    }
  }

  Widget buildBlocBuilder(BuildContext context) {
    return buildContent(context);
  }

  Widget buildBlocProvider(BuildContext context) {
    return BlocProvider<ModelsBloc<T>>(
      create: (context) {
        return ModelsBloc<T>(
          modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context),
        )..add(LoadModels<T>(id: id, parentId: parentId));
      },
      child: buildBlocBuilder(context),
    );
  }
}
