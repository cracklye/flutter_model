library flutter_model;

import 'dart:async';
import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart'; // Used in attachment_dao
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loggy/loggy.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:woue_components/woue_components.dart';

part 'modeldao/model_state.dart';
part 'model/imodel.dart';
part 'model/imodel_child.dart';
part 'modeldao/model_bloc.dart';
part 'modeldao/model_event.dart';
part 'persist/file_cache_provider.dart';
part 'persist/file_cache_writer.dart';
part 'persist/model_dao_memory.dart';
part 'persist/attachment_dao.dart';
part 'persist/model_dao.dart';
part 'widgets/model_bloc_widget.dart';
part 'widgets/model_single_page.dart';
part 'widgets/model_bloc_form_widget.dart';
