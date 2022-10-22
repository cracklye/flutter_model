part of flutter_model;

class ModelKeys {
  static Key detailFabEdit<T extends IModel>(T model) =>
      Key(getKeyModel<T>("detail_fab_edit", model.id ?? "new"));
  static Key detailListView<T extends IModel>(T model) =>
      Key(getKeyModel<T>("detail_listview", model.id ?? "new"));

  static Key detailHeroTag<T extends IModel>(T model) =>
      Key(getKeyModel<T>("detail_hero_tag", model.id ?? "new"));

  static Key detailIconDelete<T extends IModel>(T model) =>
      Key(getKeyModel<T>("detail_icon_delete", model.id ?? "new"));

  static Key editFabSaveExisting<T extends IModel>(T model) =>
      Key(getKeyModel<T>(
          "edit_fab_saveexisting", model == null ? "new" : model.id ?? "new"));
  static Key editFabSaveNew<T extends IModel>(T model) => Key(getKeyModel<T>(
      "edit_fab_savenew", model == null ? "new" : model.id ?? "new"));

  static Key filterTextbox<T extends IModel>() =>
      Key(getKey<T>("filter_textbox"));
  static Key filterButton<T extends IModel>() =>
      Key(getKey<T>("filter_button"));
  static Key filterColumn<T extends IModel>() =>
      Key(getKey<T>("filter_column"));

  static Key modelViewDetails<T extends IModel>(T model) =>
      Key(getKeyModel<T>("view_model", model.id ?? "new"));

  static Key listView<T extends IModel>() => Key(getKey<T>("list_view"));

  static Key snackbarDelete<T extends IModel>() => Key(getKey<T>("snackbar"));
  static Key snackbarTap<T extends IModel>() => Key(getKey<T>("snackbar"));

  static String getKeyModel<T extends IModel>(String key, dynamic id) {
    String modelType = getModelKeyFromType<T>();
    return "__${modelType}___{$key}__{$id}___";
  }

  static String getKey<T extends IModel>(String key) {
    String modelType = getModelKeyFromType<T>();
    return "__${modelType}___{$key}___";
  }

  static Key listItemDescription<T extends IModel>(T model) =>
      Key(getKeyModel<T>("listItemDescription", model.id ?? "new"));
  static Key listItemTitle<T extends IModel>(T model) =>
      Key(getKeyModel<T>("listItemTitle", model.id ?? "new"));
  static Key listItemDismissable<T extends IModel>(T model) =>
      Key(getKeyModel<T>("listItemDismissable", model.id ?? "new"));
  static Key listItemTile<T extends IModel>(T model) =>
      Key(getKeyModel<T>("listItemTile", model.id ?? "new"));

  static Key viewForm<T extends IModel>(T model) =>
      Key(getKeyModel<T>("listItemTile", (model.id ?? "new")));

  static const addSettingScreen = Key('__addSettingScreen__');
  static const saveNewSettingFab = Key('__saveNewSettingFab__');
  static const editSettingFab = Key('__editSettingFab__');
  static const editSettingScreen = Key('__editSettingScreen__');
  static const settingDetailsScreen = Key('__settingDetailsScreen__');
  static const modelLoading = Key('__modelLoading__');

  static const deleteSettingButton = Key('__deleteSettingButton__');
  static const detailsSettingItemKey = Key('__detailsSettingItemKey__');
  static const detailsSettingItemValues = Key('__detailsSettingItemValues__');
  static const detailsSettingItemDescription =
      Key('__detailsSettingItemDescription__');

  static const settingsLoading = Key('__settingsLoading__');
  static const settingList = Key('__settingList__');
  static const saveChangesToolTip = Key('__saveChangesToolTip_');
  //static final snackbar = const Key('__snackbar__');
  static Key snackbarAction(dynamic id) => Key('__snackbar_action_${id}__');

  static final settingItemCheckbox =
      (dynamic id) => Key('settingitem__${id}__');
  static final  settingItem = (dynamic id) => Key('settingitem__${id}__');
  static final  settingItemKey = (dynamic id) => Key('settingitem_key__${id}__');
  static final settingItemValues =
      (dynamic id) => Key('settingitem__values_${id}__');

  static const settingsFieldKey = Key('__settingsFieldKey__');
  static const settingsFieldValues = Key('__settingsFieldValues__');

  static final settingsFieldDescription =
      const Key('__settingsFieldDescription__');

  // static final routeEdit = <T extends IModel>(Stridynamicng id) => ('/${getModelKeyFromType<T>()}/edit/$id');
  // static final routeDetail = <T extends IModel>(dynamic id) => ('/${getModelKeyFromType<T>()}/detail/$id');
  // static final routeAdd = () => <T extends IModel>('/${getModelKeyFromType<T>()}/create');
  // static final routeList = () => <T extends IModel>('/${getModelKeyFromType<T>()}/list');

  static routeEdit<T extends IModel>(dynamic id, [parentId]) {
    String model = getModelKeyFromType<T>();
    if (parentId != null) {
      return '/$model/edit/$id/$parentId';
    } else {
      return '/$model/edit/$id';
    }
  }

  static routeDetail<T extends IModel>(dynamic id, [parentId]) {
    print("routeDetail id=$id, parentId=$parentId");
    String model = getModelKeyFromType<T>();
    if (parentId != null) {
      print("routeDetail() Returning : /$model/detail/$id/$parentId");
      return '/$model/detail/$id/$parentId';
    } else {
      print("routeDetail() Returning : /$model/detail/$id");
      return '/$model/detail/$id';
    }
  }

  static routeAdd<T extends IModel>(
      [dynamic parentId, Map<String, dynamic>? params]) {
    String model = getModelKeyFromType<T>();

    String rtn = "";

    if (parentId != null) {
      rtn = '/$model/create/$parentId';
    } else {
      rtn = '/$model/create';
    }

    if (params != null) {
      bool isSet = false;

      for (var key in params.keys) {
        if (isSet) {
          rtn = rtn + "&";
        } else {
          rtn = rtn + "?";
        }
        rtn = rtn + key + "=" + params[key].toString();
        isSet = true;
      }
    }
    print("routeAdd url $rtn");
    return rtn;
  }

  static routeList<T extends IModel>() {
    String model = getModelKeyFromType<T>();
    return '/$model/list';
  }
}
