// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_model/flutter_model.dart';

// enum LaunchType { dialog, navigate, inline, none }

// class OrderByListOption {
//   final String label;
//   //final List<OrderByItem> orderBy;
//   final IconData? icon;

//   OrderByListOption(
//       {required this.label,
//       //required this.orderBy,
//       this.icon});
// }

// abstract class ModelWidgetStateful<T extends IModel> extends StatefulWidget {
//   final dynamic parentId;
//   final dynamic id;
//   final BlocMode blocMode;
//   final ModelDialog<T>? modelDialog;
//   final LaunchType launchTypeEdit;
//   final LaunchType launchTypeDetail;
//   final LaunchType launchTypeAdd;

//   final List<OrderByListOption>? orderBy;

//   ModelWidgetStateful({
//     this.id,
//     this.parentId,
//     this.blocMode = BlocMode.consumer,
//     this.modelDialog,
//     key,
//     this.launchTypeEdit = LaunchType.navigate,
//     this.launchTypeDetail = LaunchType.navigate,
//     this.launchTypeAdd = LaunchType.navigate,
//     this.orderBy,
//   }) : super(key: key);
// }

// abstract class ModelWidgetStatefulState<T extends IModel,
//     S extends ModelWidgetStateful<T>> extends State<S> {
//   static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   Widget buildContent(BuildContext context);

//   void navigateToEdit(BuildContext context, T model) {
//     Navigator.of(context)
//         .pushNamed(ModelKeys.routeEdit<T>(model.id, widget.parentId));
//   }

//   void navigateToDetails(BuildContext context, T model) {
//     Navigator.of(context)
//         .pushNamed(ModelKeys.routeDetail<T>(model.id, widget.parentId));
//   }

//   void navigateToNew(BuildContext context) {
//     Navigator.of(context).pushNamed(ModelKeys.routeAdd<T>(widget.parentId));
//   }

//   void dialogEdit(BuildContext context, T model) {
//     widget.modelDialog!.showAdd(context, formKey, model, widget.parentId);
//   }

//   void dialogToDetails(BuildContext context, T model) {
//     widget.modelDialog!.showDetail(context, model, formKey,
//         (context, key, model) {
//       doEdit(context, model);
//     });
//   }

//   void dialogToNew(BuildContext context) {
//     widget.modelDialog!.showAdd(context, formKey, null, widget.parentId);
//   }

//   void doEdit(BuildContext context, T model) {
//     if (widget.launchTypeEdit == LaunchType.navigate) {
//       navigateToEdit(context, model);
//     } else if (widget.launchTypeEdit == LaunchType.dialog) {
//       dialogEdit(context, model);
//     } else {}
//   }

//   void doDetails(BuildContext context, T model) {
//     if (widget.launchTypeDetail == LaunchType.navigate) {
//       navigateToDetails(context, model);
//     } else if (widget.launchTypeDetail == LaunchType.dialog) {
//       dialogToDetails(context, model);
//     } else {}
//   }

//   void doAdd(BuildContext context) {
//     if (widget.launchTypeAdd == LaunchType.navigate) {
//       navigateToNew(context);
//     } else if (widget.launchTypeAdd == LaunchType.dialog) {
//       dialogToNew(context);
//     } else {}
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.blocMode == BlocMode.provider) {
//       return buildBlocProvider(context);
//     } else if (widget.blocMode == BlocMode.none) {
//       return buildContent(context);
//     } else {
//       return buildBlocBuilder(context);
//     }
//   }

//   Widget buildBlocBuilder(BuildContext context) {
//     return buildContent(context);
//   }

//   Widget buildBlocProvider(BuildContext context) {
//     return BlocProvider<ModelsBloc<T>>(
//       create: (context) {
//         return ModelsBloc<T>(
//           modelsRepository: RepositoryProvider.of<IModelAPI<T>>(context),
//         )..add(ModelsLoad<T>(
//             id: widget.id,
//             parentId: widget.parentId,
//             // order: widget.orderBy != null && widget.orderBy!.length > 0
//             //     ? widget.orderBy![0].orderBy
//             //     : null
//           ));
//       },
//       child: buildBlocBuilder(context),
//     );
//   }
// }
