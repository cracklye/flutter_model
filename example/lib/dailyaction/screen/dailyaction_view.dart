
// import 'package:example/action/model_action.dart';
// import 'package:example/action/widget/note_listitem.dart';
// import 'package:example/routes/app_navigator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_model/flutter_model.dart';
// import 'package:flutter_model/widgets/addin/model_bloc_addin_navigation.dart';

// class ActionScreenMobile extends ModelScreenList<Action>
//     with ModelBlocAddinNavigation {

//   ActionScreenMobile({Key? key, super.parentId})
//       : super(
//           drawer: const AppDrawer(),
//           key: key,
//           buildListItem: (context, model, onTap) => ActionListItem(
//             note: model,
//             onTap: () => onTap(model),
//           ),
//           onSelectAdd: (context) =>
//               Navigator.of(context).pushNamed(ModelRouter.routeAdd(parentId)),
//           onSelectDisplay: (context, model) => Navigator.of(context)
//               .pushNamed(ModelRouter.routeDetail(model!.id)),
//           onSelectEdit: (context, model) =>
//               Navigator.of(context).pushNamed(ModelRouter.routeEdit(model!.id)),
//           // onSelectDelete: (context, model) => print("Don't do anything"),
//         );
// }
