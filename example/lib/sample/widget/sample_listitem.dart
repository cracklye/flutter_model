import 'package:example/sample/model_sample.dart';
import 'package:flutter/widgets.dart';
import 'package:woue_components/woue_components.dart';

class SampleListItem extends StatelessWidget {
  final Sample note;
  final Function() onTap;

  const SampleListItem({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(note.displayLabel),
      subtitle: Text(note.description),
    );
  }
}
