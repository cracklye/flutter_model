import 'package:example/dailyaction/model_dailyaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_model/flutter_model.dart';


class DailyActionForm extends ModelForm<DailyAction> {
  const DailyActionForm(
      {super.key, super.model, isEditing = true, formKey, onSave, onChanged})
      : super(
            isEditing: isEditing,
            formKey: formKey,
            onSave: onSave,
            onChanged: onChanged);

  @override
  State<StatefulWidget> createState() {
    return _ProjectFormState();
  }
}

class _ProjectFormState extends ModelFormState<DailyAction> {
  String _name = "";
  String _description = "";

  @override
  void initState() {
    if (widget.model != null) {
      var model = widget.model!;

      _name = model.name;
      _description = model.description;
    }

    super.initState();
  }

  @override
  Map<String, dynamic> getValues() {
    return {
      "name": _name,
      "description": _description,
    };
  }

  @override
  List<Widget> buildFormFields(context) {
    return [
      LabelWidget(
          buildLabel: const Text("Name:"),
          buildContent: TextFormField(
            scrollController: ScrollController(),
            initialValue: _name,
            autofocus: !widget.isEditing,
            validator: (val) {
              return val!.trim().isEmpty ? 'Please enter some text' : null;
            },
            onSaved: (value) => _name = value!,
          )),
      LabelWidget(
          buildLabel: const Text("Description"),
          buildContent: TextFormField(
            scrollController: ScrollController(),
            initialValue: _description,
            onSaved: (value) => _description = value!,
          )),
    ];
  }
}
