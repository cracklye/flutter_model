
import 'package:fluro/fluro.dart';
import 'package:flutter_model/flutter_model.dart';
import 'package:loggy/loggy.dart';

/// The ModelRouter provides some static methods to enable
/// building the routing URI's based of the class type
/// and the parameters.
class ModelRouter with UiLoggy {
  static mapFromParams(Map<String, dynamic>? params) {
    if (params == null) return null;
    Map<String, dynamic> rtn = {};
    logDebug("mapFromparams: returning params");
    for (var key in params.keys) {
      if (params[key] is List) {
        logDebug("MapFromParams: Key $key, is list");
        rtn.putIfAbsent(key, () => params[key][0]);
      } else {
        logDebug("MapFromParams: Key $key, is not list");
        rtn.putIfAbsent(key, () => params[key]);
      }
    }
    return rtn;
  }

  /// Creates the router URI for model with [id] and (optionally) the [parentId]
  static routeEdit<T extends IModel>(dynamic id, [parentId]) {
    logDebug("ModelRouter.Route Edit");
    String model = getModelKeyFromType<T>();
    if (parentId != null) {
      return '/$model/edit/$id/$parentId';
    } else {
      return '/$model/edit/$id';
    }
  }

  ///Creates the router URI for model with [id] and (optionally) the [parentId]
  static routeDetail<T extends IModel>(dynamic id, [parentId]) {
    logDebug("ModelRouter.routeDetail id=$id, parentId=$parentId");
    String model = getModelKeyFromType<T>();
    if (parentId != null) {
      logDebug("routeDetail() Returning : /$model/detail/$id/$parentId");
      return '/$model/detail/$id/$parentId';
    } else {
      logDebug("routeDetail() Returning : /$model/detail/$id");
      return '/$model/detail/$id';
    }
  }

  ///Creates the router URI for adding a new model with (optionally) the [parentId]
  static routeAdd<T extends IModel>([dynamic parentId]) {
    logDebug("ModelRouter.routeAdd  parentId=$parentId");
    String model = getModelKeyFromType<T>();
    if (parentId != null) {
      return '/$model/create/$parentId';
    } else {
      return '/$model/create';
    }
  }

  /// Creates the default router URI for the list page for the model.
  static routeList<T extends IModel>() {
    logDebug("ModelRouter.routeList  ");

    String model = getModelKeyFromType<T>();
    return '/$model/list';
  }

  static routeEditByTypeName(String typeName, dynamic id, [parentId]) {
    logDebug("ModelRouter.Route Edit");

    if (parentId != null) {
      return '/${typeName.toLowerCase()}/edit/$id/$parentId';
    } else {
      return '/${typeName.toLowerCase()}/edit/$id';
    }
  }

  ///Creates the router URI for model with [id] and (optionally) the [parentId]
  static routeDetailByTypeName(String typeName, dynamic id, [parentId]) {
    logDebug("ModelRouter.routeDetail id=$id, parentId=$parentId");

    if (parentId != null) {
      logDebug("routeDetail() Returning : /$typeName/detail/$id/$parentId");
      return '/${typeName.toLowerCase()}/detail/$id/$parentId';
    } else {
      logDebug("routeDetail() Returning : /$typeName/detail/$id");
      return '/${typeName.toLowerCase()}/detail/$id';
    }
  }

  ///Creates the router URI for adding a new model with (optionally) the [parentId]
  static routeAddByTypeName(String typeName, [dynamic parentId]) {
    logDebug("ModelRouter.routeAdd  parentId=$parentId");

    if (parentId != null) {
      return '/${typeName.toLowerCase()}/create/$parentId';
    } else {
      return '/${typeName.toLowerCase()}/create';
    }
  }


  /// Creates the default router URI for the list page for the model.
  static routeListByTypeName(
    String typeName,
  ) {
    logDebug("ModelRouter.routeList  ");

    return '/${typeName.toLowerCase()}/list';
  }

  /// Sets up all the CRUD routes in the router based on the handlers passed to the function.
  ///
  /// [list] the handler to execute when the list URI is triggered
  /// [detail] the handler to execute when the detail URI is triggered
  /// [edit] the edit handler to execute when the edit URI is triggered
  /// [add] the add handler to execute when the add URI is triggered
  static routeSetupCRUD<T extends IModel>(FluroRouter router,
      {Handler? list, Handler? detail, Handler? edit, Handler? add}) {
    if (list != null) {
      logDebug("**** Adding list ${ModelRouter.routeList<T>()}");
      router.define(ModelRouter.routeList<T>(), handler: list);
    }

    if (detail != null) {
      router.define(
        ModelRouter.routeDetail<T>(":id"),
        handler: detail,
      );
    }

    if (edit != null) {
      router.define(
        ModelRouter.routeEdit<T>(":id"),
        handler: edit,
      );
    }
    if (add != null) {
      router.define(
        ModelRouter.routeAdd<T>(),
        handler: add,
      );
    }
  }

  /// Sets up all the CRUD routes for a child model in
  ///  the router based on the handlers passed to the function.
  ///
  /// [list] the handler to execute when the list URI is triggered
  /// [detail] the handler to execute when the detail URI is triggered
  /// [edit] the edit handler to execute when the edit URI is triggered
  /// [add] the add handler to execute when the add URI is triggered
  static routeSetupCRUDChild<T extends IModel, IModelChild>(FluroRouter router,
      {Handler? list, Handler? detail, Handler? edit, Handler? add}) {
        logDebug("routeSetupCRUDChild Started $T ");
    if (list != null) {
      logDebug("routeSetupCRUDChild Defined List $T ");
      router.define(ModelRouter.routeList<T>(), handler: list);
    }
    if (detail != null) {
      logDebug("routeSetupCRUDChild Detail $T ");
      router.define(
        ModelRouter.routeDetail<T>(":id", ":parentId"),
        handler: detail,
      );
    }

    if (edit != null) {
      logDebug("routeSetupCRUDChild Defined Edit $T ");
      router.define(
        ModelRouter.routeEdit<T>(":id", ":parentId"),
        handler: edit,
      );
    }
    if (add != null) {
      logDebug("routeSetupCRUDChild Defined Add $T ");
      router.define(
        ModelRouter.routeAdd<T>(":parentId"),
        handler: add,
      );
    }
  }
}
