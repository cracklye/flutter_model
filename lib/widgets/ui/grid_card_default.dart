// import 'package:flutter/material.dart';
// import 'package:flutter_model/flutter_model.dart';

// class GridCardDefault<T extends IModel> extends StatelessWidget {
//   const GridCardDefault(
//       {super.key,
//       this.backgroundImage,
//       required this.title,
//       this.colour,
//       this.subtitle});

//   final ImageProvider? backgroundImage;
//   final String title;
//   final String? subtitle;
//   final Color? colour;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           //padding: const EdgeInsets.all(5.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Expanded(
//                   child: CircleAvatar(
//                 minRadius: 30,
//                 maxRadius: 150,
//                 backgroundColor: colour,
//                 backgroundImage: backgroundImage,
//                 child: backgroundImage != null
//                     ? null
//                     : Padding(
//                         padding: const EdgeInsets.all(30.0),
//                         child: FittedBox(
//                             fit: BoxFit.fitWidth,
//                             child: Center(
//                                 child: Text(Initials.getInitials(title),
//                                     style: const TextStyle(fontSize: 500.0))))),
//               )),
//               ListTile(
//                 title: Text(title, overflow: TextOverflow.ellipsis),
//                 subtitle: subtitle!=null?Text(subtitle!, overflow: TextOverflow.ellipsis):Container(),
//               ),
//             ],
//           ),
//         ));
//   }
// }

// class Initials {
//   static getInitials(String text, [int max = 999]) {
//     var words = text.split(" ");
//     StringBuffer sb = StringBuffer();
//     for (int i = 0; i < words.length; i++) {
//       if (i < max && words[i].isNotEmpty) {
//         String s = words[i].substring(0, 1);
//         sb.write(s.toUpperCase());
//       }
//     }

//     return sb.toString();
//   }
// }
