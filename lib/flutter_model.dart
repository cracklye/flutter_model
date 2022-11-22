library flutter_model;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:fluro/fluro.dart';
import 'package:flutter_model/widgets/ui/grid_card_default.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart'; // Used in attachment_dao
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loggy/loggy.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:woue_components/woue_components.dart';

import 'package:flutter/material.dart' as m;


part 'bloc/filtered/model_filter_bloc.dart';


part 'model/orderby/order_by.dart';

part 'model/filters/filter.dart';

part 'bloc/modelbloc/model_state.dart';
part 'model/imodel.dart';
part 'model/imodel_child.dart';
part 'model/ihierarchy.dart';
part 'bloc/modelbloc/model_bloc.dart';
part 'bloc/modelbloc/model_event.dart';
part 'bloc/modeledit/model_edit_bloc.dart';

part 'bloc/model_detail_bloc/models_detail_bloc.dart';
part 'bloc/model_detail_bloc/models_detail_event.dart';
part 'bloc/model_detail_bloc/models_detail_state.dart';

part 'extensions/attachment_info_extension.dart';


part 'bloc/models_list_bloc/models_list_bloc.dart';
part 'bloc/models_list_bloc/models_list_event.dart';
part 'bloc/models_list_bloc/models_list_state.dart';
part 'bloc/handle_attachment.dart'; 

part 'persist/file_cache_provider.dart';
part 'persist/file_cache_writer.dart';
part 'persist/model_dao_memory.dart';
part 'persist/attachment_dao.dart';
part 'persist/model_dao.dart';
part 'widgets/model_bloc_widget.dart';
part 'widgets/model_single_page.dart';
part 'widgets/model_bloc_form_widget.dart';

part 'widgets/ui/extended_list_view.dart'; 
part 'widgets/ui/model_extendedlist_view.dart'; 
part 'widgets/ui/model_list.dart'; 
part 'widgets/ui/attachment_viewer.dart'; 
part 'widgets/addin/model_listbloc_addin.dart';

part 'utils/model_functions.dart'; 
part 'utils/model_keys.dart'; 
part 'utils/model_routes.dart'; 
part 'widgets/ui/model_list_searchbox.dart'; 
