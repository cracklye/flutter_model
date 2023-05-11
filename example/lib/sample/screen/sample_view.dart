
// import 'package:example/Sample/model_Sample.dart';
// import 'package:example/Sample/widget/note_listitem.dart';
// import 'package:example/routes/app_navigator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_model/flutter_model.dart';
// import 'package:flutter_model/widgets/addin/model_bloc_addin_navigation.dart';

// class SampleScreenMobile extends ModelScreenList<Sample>
//     with ModelBlocAddinNavigation {

//   SampleScreenMobile({Key? key, super.parentId})
//       : super(
//           drawer: const AppDrawer(),
//           key: key,
//           buildListItem: (context, model, onTap) => SampleListItem(
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
