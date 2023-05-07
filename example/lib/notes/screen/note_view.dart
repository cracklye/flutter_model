
// import 'package:example/notes/model_notes.dart';
// import 'package:example/notes/widget/note_listitem.dart';
// import 'package:example/routes/app_navigator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_model/flutter_model.dart';
// import 'package:flutter_model/widgets/addin/model_bloc_addin_navigation.dart';

// class NotesScreenMobile extends ModelScreenList<Notes>
//     with ModelBlocAddinNavigation {

//   NotesScreenMobile({Key? key, super.parentId})
//       : super(
//           drawer: const AppDrawer(),
//           key: key,
//           buildListItem: (context, model, onTap) => NotesListItem(
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
