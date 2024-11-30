import 'package:flutter/material.dart';

class LabelGroup extends StatelessWidget {
  const LabelGroup({super.key, required this.label, this.icon});
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    icon == null ? Container() : Icon( icon),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  ],
                )),
            Divider(
              color: Colors.grey[300],
            )
          ],
        ));
  }
}
