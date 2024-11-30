import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  const PageHeader(
      {super.key, this.title, this.actions, this.row2, this.leading});
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? row2;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          Row(children: [
            leading ?? Container(),
            (title == null)
                ? Container()
                : Text(
                    title!,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
            Expanded(child: Container()),
            ...actions ?? []
          ]),
          row2 ?? Container(),
        ],
      ),
    );
  }
}
