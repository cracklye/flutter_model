import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_model/flutter_model.dart';


enum PopupType { bottom, dialog }

abstract class ModelDialog<T extends IModel> {
  final double? dialogHeight;
  final double? dialogWidth;
  final PopupType popupType;
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final bool enableEdit;

  ModelDialog(
      {this.dialogHeight,
      this.dialogWidth,
      this.popupType = PopupType.dialog,
      // @required this.formKey,
      this.enableEdit = true});

  Widget buildForm(
      GlobalKey<FormState> formKey, BuildContext context, T? model, onSave, parentId);
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
      Function(BuildContext, GlobalKey<FormState>, T) onEdit) {
    if (popupType == PopupType.dialog) {
      // showDialog(context: context, builder: _showModelBuilder(context, model));

      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: getTitleDisplay(context, model),
            // content: buildModelDisplay(context, model),

            content: SizedBox(
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
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              enableEdit
                  ? TextButton(
                      child: const Text("Edit"),
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
      showModalBottomSheet(
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
          color: Colors.transparent,
          child: Container(
            height: 230,
            decoration: const BoxDecoration(
                color: Colors.white,
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
                        child: CircleAvatar(
                          backgroundColor: Colors.indigoAccent,
                          radius: 18,
                          child: IconButton(
                            icon: const Icon(
                              Icons.save,
                              size: 22,
                              color: Colors.white,
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
    if (popupType == PopupType.dialog) {
      //print("modelDialog.  showAdd($model, $parentId)");
      //showDialog(context: context, builder: _addModelBuilder(context, model));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog

          return BlocProvider<ModelEditBloc<T>>(
              create: (context) {
                //print("modelDialog about to create the edit bloc provider");
                return createEditBloc(context, model?.id, parentId);
              },
              child: AlertDialog(
                title: const Text("Edit"),
                // content: Text("Hi"),
                content: SizedBox(
                  height: getDialogHeight(),
                  width: MediaQuery.of(context).size.width - 10,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      child: BlocConsumer<ModelEditBloc<T>, ModelEditState<T>>(
                          listener: (context, state) {
                        // print("Listener has been called $state");

                        if (state is ModelEditStateSaved<T>) {
                          //if (this._overlayEntry != null) this._overlayEntry.remove();
                          Navigator.pop(context);
                        }
                      }, builder: (context, state) {
                        return ListBody(
                          children: <Widget>[
                            buildForm(formKey, context, model, (values) {
                              if (model != null && model.id!=null) {
                                BlocProvider.of<ModelEditBloc<T>>(context).add(
                                  ModelEditEventSave<T>(
                                    values,
                                    id: model.id,
                                  ),
                                );
                              } else {
                                print("saving new doc");
                                
                                BlocProvider.of<ModelEditBloc<T>>(context).add(
                                  ModelEditEventSave<T>(values, parentId: parentId),
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
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Save"),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                      }
                    },
                  ),
                ],
              ));
        },
      );
    } else {
      showModalBottomSheet(
          context: context,
          builder: _addModelBuilder(context, formKey2, model, parentId));
    }
  }

  ModelEditBloc<T> createEditBloc(context, dynamic id, dynamic parentId) {
    return ModelEditBloc<T>(
      RepositoryProvider.of<IModelAPI<T>>(context),
        RepositoryProvider.of<AttachmentDAO>(context),
        // modelsBloc: BlocProvider.of<ModelsBloc<T>>(context)
        
        

        // id,
        // parentId
        )..add(ModelEditEventCreateNew(parentId));
  }

  _addModelBuilder(
      BuildContext context, GlobalKey<FormState> formKey, T? model, parentId) {
    return (builder) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          color: Colors.transparent,
          child: Container(
            height: 230,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: Padding(
                padding:
                   const  EdgeInsets.only(left: 15, top: 25.0, right: 15, bottom: 30),
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
                           
                            BlocProvider.of<ModelEditBloc<T>>(context).add(
                              ModelEditEventSave<T>(values, parentId: parentId),
                            );
                          }
                        }, parentId)),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, top: 15),
                          child: CircleAvatar(
                            backgroundColor: Colors.indigoAccent,
                            radius: 18,
                            child: IconButton(
                              icon: const Icon(
                                Icons.save,
                                size: 22,
                                color: Colors.white,
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
