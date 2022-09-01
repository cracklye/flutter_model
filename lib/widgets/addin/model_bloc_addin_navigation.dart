import 'package:flutter/widgets.dart';
import 'package:flutter_model/flutter_model.dart';

class ModelBlocAddinNavigation<T extends IModel> {
  void gotoEditPage(BuildContext context, T model) {}
  void gotoListPage(BuildContext context, T model) {}
  void gotoDetailPage(BuildContext context, T model) {}
}
