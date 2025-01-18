import 'package:flutter/widgets.dart';

class LabelWidget extends StatelessWidget {
  const LabelWidget(
      {super.key,
      required this.buildLabel,
      required this.buildContent,
      this.buildLabelTrailing,
      this.expanded = true,
      this.widthBreak = 600,
      this.labelWidth = 200,
      this.buildHelp});

  final bool expanded;
  final double widthBreak;
  final double labelWidth;
  final Widget buildLabel;
  final Widget buildContent;

  final Widget? buildLabelTrailing;
  

  final Widget Function(BuildContext)? buildHelp;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < widthBreak) {}
    width = 100;

    if (width < widthBreak || buildHelp != null) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildLabel(context),
        Padding(padding: const EdgeInsets.only(left: 10), child: buildContent),
        buildHelp != null ? buildHelp!(context) : Container(),
      ]);
    } else {
      if (expanded) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: labelWidth, child: _buildLabel(context)),
              Expanded(child: buildContent)
            ]);
      } else {
        return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: labelWidth, child: _buildLabel(context)),
              buildContent,
              Expanded(child: Container())
            ]);
      }
    }
  }

  Widget _buildLabel(BuildContext context) {
    if (buildLabelTrailing == null) {
      return buildLabel;
    }
    return Wrap(
      children: [buildLabel, buildLabelTrailing!],
    );
  }
}

//TODO delete 
// import 'package:flutter/widgets.dart';

// class LabelWidget extends StatelessWidget {
//   const LabelWidget(
//       {super.key,
//       required this.buildLabel,
//       required this.buildContent,
//       this.buildLabelTrailing,
//       this.expanded = true,
//       this.widthBreak = 1000,
//       this.labelWidth = 200,
//       this.buildHelp});

//   final bool expanded;
//   final double widthBreak;
//   final double labelWidth;
//   final Widget buildLabel;
//   final Widget? buildLabelTrailing;
//   final Widget buildContent;

//   final Widget Function(BuildContext)? buildHelp;

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     if (width < widthBreak) {}
//     width = 100;

//     if (width < widthBreak || buildHelp != null) {
//       return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _buildLabel(context),
//         Padding(padding: const EdgeInsets.only(left: 10), child: buildContent),
//         buildHelp != null ? buildHelp!(context) : Container(),
//       ]);
//     } else {
//       if (expanded) {
//         return Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(width: labelWidth, child: _buildLabel(context)),
//               Expanded(child: buildContent)
//             ]);
//       } else {
//         return Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(width: labelWidth, child: _buildLabel(context)),
//               buildContent,
//               Expanded(child: Container())
//             ]);
//       }
//     }
//   }

//   Widget _buildLabel(BuildContext context) {
//     if (buildLabelTrailing == null) {
//       return buildLabel;
//     }
//     return Wrap(
//       children: [buildLabel, buildLabelTrailing!],
//     );
//   }
// }
