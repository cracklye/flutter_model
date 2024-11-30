import 'package:example/dailyaction/model_dailyaction.dart';
import 'package:flutter/material.dart';


class DailyActionListItem extends StatelessWidget {
  final DailyAction note;
  final Function() onTap;

  const DailyActionListItem(
      {super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(note.displayLabel),
      subtitle: Text(note.description),
    );
  }
}
