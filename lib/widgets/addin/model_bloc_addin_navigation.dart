// import 'package:flutter/widgets.dart';
// import 'package:flutter_model/flutter_model.dart';

// class ModelBlocAddinNavigation<T extends IModel> {
//   void gotoEditPage(BuildContext context, T model, LaunchType launchType) {
//     Navigator.of(context)
//         .pushNamed(ModelKeys.routeEdit<T>(model.id, 
//         //TODO model.parentId
//         ));

//     // if (launchType == LaunchType.Navigate) {
//     //   Navigator.of(context)
//     //       .pushNamed(ModelKeys.routeEdit<T>(model.id, model.parentId));
//     // } else if (launchType == LaunchType.Dialog) {

//     //   modelDialog!.showAdd(context, formKey, model, parentId);
//     // } else {}
//   }

//   void gotoDetailPage(BuildContext context, LaunchType launchType, T model) {
//     Navigator.of(context)
//         .pushNamed(ModelKeys.routeDetail<T>(model.id,
//         //TODO model.parentId
//         ));
//   }

//   void gotoNewPage(
//       BuildContext context, LaunchType launchType, dynamic parentId) {
//     Navigator.of(context).pushNamed(ModelKeys.routeAdd<T>(parentId));
//   }

//   void gotoListPage(
//       BuildContext context, LaunchType launchType, dynamic parentId) {
//     Navigator.of(context).pushNamed(ModelKeys.routeList<T>());
//   }
// }
