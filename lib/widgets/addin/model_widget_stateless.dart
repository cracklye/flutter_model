part of flutter_model;

enum BlocMode { Consumer, Provider, None }

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
    this.blocMode = BlocMode.Consumer,
    this.modelDialog,
    this.orderBy,
    key,
    this.launchTypeEdit = LaunchType.Navigate,
    this.launchTypeDetail = LaunchType.Navigate,
    this.launchTypeAdd = LaunchType.Navigate,
  }) : super(key: key){
    
    print("StatelessWidget orderBy: ${this.orderBy} ");
  }
  



  Widget buildContent(BuildContext context);

  void navigateToEdit(BuildContext context, T model) {
   // print("navigateToEdit($model, $parentId)");
    Navigator.of(context)
        .pushNamed(ModelKeys.routeEdit<T>(model.id, parentId));
  }

  void navigateToDetails(BuildContext context, T model) {
    Navigator.of(context).pushNamed(ModelKeys.routeDetail<T>(model.id, parentId));
  }

  void navigateToNew(BuildContext context) {
    Navigator.of(context).pushNamed(ModelKeys.routeAdd<T>(parentId));
  }

  void dialogEdit(BuildContext context, T model) {
    modelDialog!.showAdd(context, formKey, model,parentId);
  }

  void dialogToDetails(BuildContext context, T model) {
    modelDialog!.showDetail(context, model, formKey , (context,key,model){
      doEdit(context, model);
    });
  }

  void dialogToNew(BuildContext context) {
    modelDialog!.showAdd(context, formKey, null,  parentId);
  }

  void doEdit(BuildContext context, T model) {
    if (launchTypeEdit == LaunchType.Navigate) {
      navigateToEdit(context, model);
    } else if (launchTypeEdit == LaunchType.Dialog) {
      dialogEdit(context, model);
    } else {}
  }

  void doDetails(BuildContext context, T model) {
    if (launchTypeDetail == LaunchType.Navigate) {
      navigateToDetails(context, model);
    } else if (launchTypeDetail == LaunchType.Dialog) {
      dialogToDetails(context, model);
    } else {}
  }

  void doAdd(BuildContext context) {
    if (launchTypeAdd == LaunchType.Navigate) {
      navigateToNew(context);
    } else if (launchTypeAdd == LaunchType.Dialog) {
      dialogToNew(context);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    if (blocMode == BlocMode.Provider) {
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
