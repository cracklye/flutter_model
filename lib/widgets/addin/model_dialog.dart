part of flutter_model;

enum PopupType { Bottom, Dialog }

abstract class ModelDialog<T extends IModel> {
  final double? dialogHeight;
  final double? dialogWidth;
  final PopupType popupType;
  final GlobalKey<FormState> formKey2 = new GlobalKey<FormState>();
  final bool enableEdit;

  ModelDialog(
      {this.dialogHeight,
      this.dialogWidth,
      this.popupType = PopupType.Dialog,
      // @required this.formKey,
      this.enableEdit = true});

  Widget buildForm(
      GlobalKey formKey, BuildContext context, T? model, onSave, parentId);
  Widget buildModelDisplay(BuildContext context, T model);

  double getDialogHeight() {
    return 300;
  }

  double getDialogWidth() {
    return 600;
  }

  Widget getTitleDisplay(BuildContext context, T model) {
    return Text(model.displayLabel);
  }

  // Shows the detail form..
  void showDetail(BuildContext context, T model, GlobalKey<FormState> formKey,
      Function(BuildContext, GlobalKey, T) onEdit) {
    if (popupType == PopupType.Dialog) {
      // showDialog(context: context, builder: _showModelBuilder(context, model));

      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return m.AlertDialog(
            title: getTitleDisplay(context, model),
            // content: buildModelDisplay(context, model),

            content: Container(
              height: getDialogHeight(),
              width: MediaQuery.of(context).size.width - 10,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      buildModelDisplay(context, model),

                      // errorMsg != null ? Text(errorMsg) : Container(),
                      // inProgress ? Text("LOADING") : Container(),
                    ],
                  ),
                ),
              ),
            ),

            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              enableEdit
                  ? TextButton(
                      child: new Text("Edit"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        //showAdd(context, formKey, model);
                        onEdit(context, formKey, model);
                      },
                    )
                  : Container(),
            ],
          );
        },
      );
    } else {
      m.showModalBottomSheet(
          context: context,
          builder: _showModelBuilder(context, formKey, model));
    }
  }

  _showModelBuilder(
      BuildContext context, GlobalKey<FormState> formKey, T model) {
    return (builder) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          color: m.Colors.transparent,
          child: Container(
            height: 230,
            decoration: const BoxDecoration(
                color: m.Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, top: 25.0, right: 15, bottom: 30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildModelDisplay(context, model),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, top: 15),
                        child: m.CircleAvatar(
                          backgroundColor: m.Colors.indigoAccent,
                          radius: 18,
                          child: IconButton(
                            icon: const Icon(
                              m.Icons.save,
                              size: 22,
                              color: m.Colors.white,
                            ),
                            onPressed: () {
                              showAdd(context, formKey, model);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ),
      );
    };
  }

  void showAdd(BuildContext context, GlobalKey<FormState> formKey,
      [T? model, parentId]) {
    if (popupType == PopupType.Dialog) {
      print("modelDialog.  showAdd($model, $parentId)");
      //showDialog(context: context, builder: _addModelBuilder(context, model));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog

          return BlocProvider<ModelEditBloc<T>>(
              create: (context) {
                print("modelDialog about to create the edit bloc provider");
                return createEditBloc(context, model?.id, parentId);
              },
              child: m.AlertDialog(
                title: Text("Edit"),
                // content: Text("Hi"),
                content: Container(
                  height: getDialogHeight(),
                  width: MediaQuery.of(context).size.width - 10,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      child: BlocConsumer<ModelEditBloc<T>, ModelEditState<T>>(
                          listener: (context, state) {
                        print("Listener has been called $state");

                        if (state is ModelEditStateSaved<T>) {
                          //if (this._overlayEntry != null) this._overlayEntry.remove();
                          Navigator.pop(context);
                        }
                      }, builder: (context, state) {
                        return ListBody(
                          children: <Widget>[
                            buildForm(formKey2, context, model, (values) {
                              if (model != null) {
                                BlocProvider.of<ModelEditBloc<T>>(context).add(
                                  ModelEditEventSave<T>(
                                    values,
                                    id: model.id,
                                  ),
                                );
                              } else {
                                print("saving new doc");
                                BlocProvider.of<ModelEditBloc<T>>(context).add(
                                  ModelEditEventSave<T>(values),
                                );
                              }
                            }, parentId),

                            // errorMsg != null ? Text(errorMsg) : Container(),
                            // inProgress ? Text("LOADING") : Container(),
                          ],
                        );
                      }),
                    ),
                  ),
                ),

                // Container(
                //     height: 230, child: Expanded(child: buildForm(context, model))),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("Save"),
                    onPressed: () {
                      if (formKey2.currentState!.validate()) {
                        formKey2.currentState!.save();
                      }
                    },
                  ),
                ],
              ));
        },
      );
    } else {
      m.showModalBottomSheet(
          context: context,
          builder: _addModelBuilder(context, formKey2, model, parentId));
    }
  }

  ModelEditBloc<T> createEditBloc(context, dynamic id, dynamic parentId) {
    print("ModelDialog.createEditBloc create edit blco");
    return ModelEditBloc<T>(
        // modelsBloc: BlocProvider.of<ModelsBloc<T>>(context)
        RepositoryProvider.of<IModelAPI<T>>(context),
        id,
        parentId);
  }

  _addModelBuilder(
      BuildContext context, GlobalKey<FormState> formKey, T? model, parentId) {
    return (builder) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          color: m.Colors.transparent,
          child: Container(
            height: 230,
            decoration: const BoxDecoration(
                color: m.Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: Padding(
                padding:
                    EdgeInsets.only(left: 15, top: 25.0, right: 15, bottom: 30),
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            //height: 400,
                            child: buildForm(formKey2, context, null, (values) {
                          if (model != null) {
                            BlocProvider.of<ModelEditBloc<T>>(context).add(
                              ModelEditEventSave<T>(values,
                                  id: model.id, parentId: parentId),
                            );
                          } else {
                            print("saving new doc");
                            BlocProvider.of<ModelEditBloc<T>>(context).add(
                              ModelEditEventSave<T>(values, parentId: parentId),
                            );
                          }
                        }, parentId)),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, top: 15),
                          child: m.CircleAvatar(
                            backgroundColor: m.Colors.indigoAccent,
                            radius: 18,
                            child: IconButton(
                              icon: const Icon(
                                m.Icons.save,
                                size: 22,
                                color: m.Colors.white,
                              ),
                              onPressed: () {
                                if (formKey2.currentState!.validate()) {
                                  formKey2.currentState!.save();
                                  // if (isEditing) {
                                  //   BlocProvider.of<ModelsBloc<T>>(context).add(
                                  //     UpdateModel<T>(model.copy(getValuesFromForm())),
                                  //   );
                                  // } else {
                                  //   BlocProvider.of<ModelsBloc<T>>(context).add(
                                  //     AddModel<T>(getModelFromForm(getValuesFromForm())),
                                  //   );
                                  // }
                                  // Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )),
          ),
        ),
      );
    };
  }
}
