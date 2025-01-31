library json_validator;

import 'package:path_provider/path_provider.dart';
import 'package:urodziny_imieniny/interfaces/file_backupable.dart';
import 'package:urodziny_imieniny/models/person.dart';
import 'package:urodziny_imieniny/models/person_bday_nday.dart';
import 'package:urodziny_imieniny/services/file_managers/json_validators/json_validator.dart';
import 'package:urodziny_imieniny/services/people_events.dart';
import 'package:urodziny_imieniny/types/operation_result.dart';
import 'dart:convert';
import 'dart:io';

part './people_file_manager.dart';


abstract class JsonFileManager<T extends JsonSerializeable> implements FileBackupable{

  JsonFileManager(this._fileName, this._items, this._validator);

  final String _fileName;
  final JsonValidator _validator;
  
  List<T> _items = List<T>.empty();
  List<T> get items => _items;
  
  /// in case file can not be read or created, or anyhow become useless
  bool _isFault = true;
  bool get fault => _isFault;

  Future<String> get filePath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }

  /// TODO linter says not referenced but it is
  /// updates [_items] as per json string
  bool _decodeJsonToItems(String json);
  

  /// read it and set [_items]
  /// NOTE: this method also sets [_isFault]
  Future<void> init() async{
    if ( await _initFile()){ 
      var fp = await filePath;
      var result = await loadItems(fp);
      _isFault = ! result.isSuccess;
    } else {
      _isFault = true;
    }
  }

  /// should initialize the file, i.e. create empty one if not exists
  Future<bool> _initFile() async{
    final file = File(await filePath);

    if (!(await file.exists())) {
      try{
        await file.writeAsString(jsonEncode([]));
        return true;
      } catch (e){
        return false;
      }
    } else {
      return true;
    }
  }

  Future<OperationResult> addItem(T item);

  Future<OperationResult> removeItem(String identifier);

  /// reads from json [_fileName] -> [_items]
  Future<OperationResult> loadItems(String filePath);

  /// save [_items] -> json [_fileName] file
  Future<OperationResult> saveItems();

  String _encodeItemsToJsonString(List<T> items){
    var mapped = items.map((e) => e.toJson()).toList();   
    return jsonEncode(mapped);
  }

  Future<bool> _saveJsonToFile(String jsonString) async
  {
    try{
      final file = File(await filePath);
      await file.writeAsString(jsonString);
    } catch (e) {
      return false;
    }
    return true;
  }
}