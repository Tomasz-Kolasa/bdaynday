part of 'json_file_manager.dart';



/// app state: ApplicationDocumentsDirectory JSON file <-> MyAppState::people 
/// app state backup/restore: ApplicationDocumentsDirectory JSON file <-> ExternalStorageDirector JSON file
class PeopleFileManager extends JsonFileManager<Person>
{
  PeopleFileManager(super.fileName, super.items, super._validator);

  @override
  String get backupFileName => 'people_backup.json';

  /// adds a person to JSON file
  /// returns (isScuccess, reason)
  @override
  Future<OperationResult> addItem(Person person) async
  {
    if (! _items.any( (x)=>x.name==person.name )) {
      _items.add(person);

      var result = await saveItems();

      if(result.isSuccess ){
        return OperationResult(isSuccess: true);
      }
      else
      {
        _items.removeWhere((p)=>p.name==person.name);
        return OperationResult(reason: 'Nie można zapisać osób');
      }
    }
    else
    {
      return OperationResult(reason: 'Osoba już istnieje');
    }
  }


  /// Removes person by name
  @override
  Future<OperationResult> removeItem(String name) async
  {
    var people = _items.where( (p)=>p.name==name );

    assert(people.length==1);

    if(people.length==1)
    {
      var personCopy = Person(
        name: name,
        birthday: people.first.birthday,
        nameday: people.first.nameday
      );

      _items.removeWhere((p)=>p.name==name );

      if(await _saveJsonToFile(_encodeItemsToJsonString(_items))){
        return OperationResult(isSuccess: true);
      }
      else
      {
        _items.add(personCopy);
        
        return OperationResult(reason: 'nie usunąć osoby');
      }

    } else {
      return OperationResult(reason: 'wystąpił problem z aplikacją');
    }
  }

  @override
  Future<OperationResult> loadItems(String filePath) async {
    try {
      final file = File(filePath);

      final contents = await file.readAsString();
      _decodeJsonToItems(contents);

      return OperationResult(isSuccess: true);

    } catch (e) {
      return OperationResult(isSuccess: false);
    }
  }
  
  @override
  Future<OperationResult> saveItems() async {
      if(await _saveJsonToFile(_encodeItemsToJsonString(_items))){
        return OperationResult(isSuccess: true);
      }
      else
      {
        return OperationResult(isSuccess: false);
      }
  }


  @override
  bool _decodeJsonToItems(String json){
    if(_validator.isJsonFormatOk(json))
    {
      List<dynamic> jsonList = jsonDecode(json);

      var people = jsonList.map((json) => Person.fromJson(json)).toList();

      _items.clear();
      _items.addAll(people);

      return true;
    } else {
      return false;
    }
  }
  
  @override
  Future<bool> backup(String destinationDir) async {
    try{
      final file = File('$destinationDir/$backupFileName');
      await file.writeAsString( _encodeItemsToJsonString(items) );
    } catch(e){
      return false;
    }
    return true;
  }
  
  @override
  Future<bool> restoreBackup(String filePath) async {

    var result = await loadItems(filePath);

    if(result.isSuccess){
      return true;
    } else{
      return false;
    }
  }
}