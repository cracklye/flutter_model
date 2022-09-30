part of flutter_model;

/// Extends the Form class and adds a onSave function so that
/// once the form has completed the save functionality it can notify
/// the parent widget and appropriate actions can be taken then.
class FormNotify extends Form {
  final Function() onSaved;

  FormNotify({
    Key? key,
    @required child,
    autovalidate = false,
    onWillPop,
    onChanged,
    required this.onSaved,
  }) : super(
            key: key,
            child: child,
            //autovalidate: autovalidate,
            onWillPop: onWillPop,
            onChanged: onChanged);

  @override
  FormNotifyState createState() => FormNotifyState();
}

class FormNotifyState extends FormState {
  /// Saves every [FormField] that is a descendant of this [Form].
  @override
  void save() {
    super.save();
    FormNotify w = widget as FormNotify;
    w.onSaved();
  }
}

abstract class ModelForm<T extends IModel> extends StatefulWidget {
  final T? model;
  final dynamic parentId;
  final bool isEditing;
  final Key? formKey;
  //final registerGetValues;
  final void Function(Map<String, dynamic>) onSave;
  final void Function()? onChanged;

  ModelForm(
      {required this.model,
      this.isEditing = true,
      required this.formKey,
      required this.onSave,
      this.onChanged,
      this.parentId});
}

abstract class ModelFormState<T extends IModel> extends State<ModelForm<T>> {
  //Map<String, dynamic> getFormData();

  ModelFormState();

  List<Widget> buildFormFields(BuildContext context);

  Map<String, dynamic> getValues();

  @override
  Widget build(BuildContext context) {
    return FormNotify(
      key: widget.formKey,
      onSaved: () => widget.onSave(getValues()),
      onChanged: () {
        if (widget.onChanged != null) {
          widget.onChanged!();
        }
      },
      child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(children: buildFormFields(context))),
    );
  }
}
