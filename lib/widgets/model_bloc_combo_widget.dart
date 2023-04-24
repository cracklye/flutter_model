// part of flutter_model;

// class ModelFormFieldCombo<T extends IModel> extends FormField<T> {
//   ModelFormFieldCombo(
//       {
//         FormFieldSetter<T>? onSaved,
//       FormFieldValidator<T>? validator,
//       required T? initialValue,
//       bool autovalidate = false,
//       required dynamic Function(dynamic Function(T), T?) buildChild}
//       )
//       : super(
//             onSaved: onSaved,
//             validator: validator,
//             initialValue: initialValue,
//            // autovalidate: autovalidate,
//             builder: (FormFieldState<T> state) {
//               return Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   buildChild((T value) {
//                     state.didChange(value);
//                   }, initialValue),
//                 ],
//               );
//             });
// }

// abstract class ModelCombo<T extends IModel> extends StatefulWidget {
//   final T initialValue;
//   final bool enableNull;
//   final onSelectionChanged;
//   final label;
//   final bool enabled; 


//   ModelCombo(
//       {required this.initialValue,
//       this.enableNull =false,
//       this.onSelectionChanged,
//       this.label, this.enabled = true});
// }

// class ModelComboState<T extends IModel> extends State<ModelCombo> {
  
//   T? selectedValue;

//   List<DropdownMenuItem<T>> getDropDownMenuItems(models) {
//     print("getDropDownMenuItems Combo selected value: $selectedValue");
//     List<DropdownMenuItem<T>> items = [];
//     for (T model in models) {
//       items.add(new DropdownMenuItem(
//           value: model, child: buildItem(model)));
//     }
//     return items;
//   }


//   Widget buildItem(T model){
//     return new Text(model.getdisplayLabel());
    
//   }

//   @override
//   void initState() {
//     super.initState();
//     selectedValue = widget.initialValue as T?;
//     print("Combo selected value: $selectedValue");
//   }

//   Widget buildContainer3(
//       BuildContext context, List<DropdownMenuItem<T>> dropDownMenuItems) {
        
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
//       child: Container(
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(5),
//               boxShadow: [BoxShadow(color: Colors.black26, spreadRadius: 1)]),
//           child: Row(
//             //crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Expanded(
//                 child: DropdownButtonHideUnderline(
                  
//                   child: ButtonTheme(
//                     alignedDropdown: true,
//                     child: DropdownButton(
                      
//                       hint:Text( widget.label??""),
//                       value: selectedValue,
//                       items: dropDownMenuItems,
//                       onChanged:widget.enabled? changedDropDownItem:null,
//                       //style: Theme.of(context).textTheme.title,
//                     ),
//                   ),
//                 ),
//               ),
//               widget.enableNull
//                   ? IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () {
//                         changedDropDownItem(null);
//                       },
//                     )
//                   : Container()
//             ],
//           )),
//     );
//   }

//   Widget buildContainerNew(
//       BuildContext context, List<DropdownMenuItem<T>> dropDownMenuItems) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
//       width: 500,
//       decoration: BoxDecoration(
//           color: Colors.blue, borderRadius: BorderRadius.circular(5)),

//       // dropdown below..
//       child: DropdownButton<T>(
//         value: selectedValue,
//         items: dropDownMenuItems,
//         onChanged: changedDropDownItem,
//         icon: Icon(Icons.arrow_drop_down),
//         iconSize: 36,
//         underline: SizedBox(),
//       ),
//     );
//   }

//   Widget buildContainerOld(
//       BuildContext context, List<DropdownMenuItem<T>> dropDownMenuItems) {
//     return new Container(
//       color: Colors.white,
//       child: new Center(
//           child: new Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           widget.label != null ? new Text(widget.label) : Container(),
//           new Container(
//             padding: new EdgeInsets.all(16.0),
//           ),
//           new DropdownButton<T>(
//             value: selectedValue,
//             items: dropDownMenuItems,
//             onChanged: changedDropDownItem,
//           ),
//           widget.enableNull
//               ? FlatButton(
//                   child: Text("X"),
//                   onPressed: () {
//                     changedDropDownItem(null);
//                   },
//                 )
//               : Container()
//         ],
//       )),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ModelsBloc<T>, ModelsState<T>>(
//       builder: (context, state) {
//         if (state is ModelsLoading<T>) {
//           return LoadingIndicator();
//         } else if (state is ModelsLoaded<T>) {
//           final models = state.models;
//           final _dropDownMenuItems = getDropDownMenuItems(models);

//           if (selectedValue != null && !models.contains(selectedValue)) {
//             print("Selected Value: $selectedValue");
//             print("Models: $models");
//             return ErrorDisplayWidget(
//               title: "Error Occurred",
//               message: "The selected item does not exist in the list",
//               displayType: ErrorDisplayWidgetType.Small,
//             );
//           }
//           return buildContainer3(context, _dropDownMenuItems);
//         } else {
//           return Container();
//         }
//       },
//     );
//   }

//   void changedDropDownItem(T? model) {
//     print("Have changed the object $model");
//     print("Have changed the onSelectionChanged ${widget.onSelectionChanged}");
//     if (widget.onSelectionChanged != null) widget.onSelectionChanged(model);
//     setState(() {
//       selectedValue = model;
//     });
//   }
// }

