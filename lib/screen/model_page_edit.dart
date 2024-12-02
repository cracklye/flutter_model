// import 'package:flutter/material.dart';
// import 'package:flutter_model/flutter_model.dart';
// import 'package:flutter_model/widgets/addin/model_detail.dart';
// import 'package:loggy/loggy.dart';

// abstract class ModelFormPage<T extends IModel> extends StatelessWidget
//     with ModelDetail<T>, UiLoggy {
//   ModelFormPage(
//       {super.key,
//       this.id,
//       this.parentId,
//       this.initialValues,
//       GlobalKey<FormState>? formkey,
//       this.additionalActions})
//       : formKey = formkey ?? GlobalKey<FormState>();

//   final dynamic id;
//   final dynamic parentId;
//   final Map<String, dynamic>? initialValues;
//   final GlobalKey<FormState> formKey;
//   final List<Widget>? Function(T? note)? additionalActions;

//   @override
//   Widget build(BuildContext context) {
//     if (id == null) {
//       return buildEditForm(context, null);
//     } else {
//       return buildBlocProvider(context, id, (() {
//         Navigator.pop(context);
//       }));
//     }
//   }

//   @override
//   Widget buildBlocLoaded(BuildContext context, ModelsDetailLoaded<T> state) {
//     T model = state.model;
//     return buildEditForm(context, model);
//   }

//   Widget buildEditForm(BuildContext context, T? model) {
//     (model);

//     return Scaffold(
//         appBar: AppBar(
//           leading: const BackButton(
//               //     color: Colors.black,
//               ),
//           title: Text(model == null ? "Create" : "Edit ${model.displayLabel}",
//               overflow: TextOverflow.ellipsis),
//           actions: [
//             IconButton(
//                 onPressed: (() {
//                   if (formKey.currentState!.validate()) {
//                     formKey.currentState!.save();
//                   }
//                 }),
//                 icon: const Icon(Icons.save)),
//             id != null
//                 ? IconButton(
//                     onPressed: (() => loggy.debug("delete pressed")),
//                     icon: const Icon(Icons.delete))
//                 : Container(),
//             ...(additionalActions == null ? null : additionalActions!(model)) ??
//                 []
//           ],
//         ),
//         body: Padding(
//             padding: const EdgeInsets.all(15),
//             child: buildForm(context, model, parentId, initialValues)
//             // ProjectForm();
//             ));
//   }

//   Widget buildForm(BuildContext context, T? model, dynamic parentId,
//       Map<String, dynamic>? initialValues);
// }
