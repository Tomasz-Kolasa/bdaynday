import 'package:flutter/widgets.dart';
import 'package:urodziny_imieniny/models/day_month.dart';
import 'package:urodziny_imieniny/services/file_managers/json_file_manager.dart';
import 'package:urodziny_imieniny/services/file_managers/json_validators/people_json_validator.dart';
import 'package:urodziny_imieniny/types/operation_result.dart';
import '../models/person.dart';
import '../models/person_bday_nday.dart';
import '../services/people_events.dart';

class MyAppState extends ChangeNotifier {

  MyAppState()
  {
    _fileManagers['people'] = PeopleFileManager('people.json', _people, PeopleJsonValidator());
    _initAppStates();
  }

  List<Person> _people = <Person>[];
  List<Person> get people => _people;  // TODO return list deep copy to ensure encapsulation

  List<PersonBdayNday> _peopleEvents = <PersonBdayNday>[];
  List<PersonBdayNday> get peopleEvents => _peopleEvents; // TODO return list deep copy to ensure encapsulation

  /// will show user a snackbar at app scaffold
  List<String> userInfoMessages = [];

  late Map<String, JsonFileManager> _fileManagers = {};


  /// during init the following takes place:
  /// - create files if not exists
  /// - read each FileManeger file content
  /// - create ChangeNotifier states from FileManagers [items]
  Future<void> _initAppStates() async{
    for (var key in _fileManagers.keys) {
      await _fileManagers[key]!.init();
      if(_fileManagers[key]!.fault){
        addUserMessage('błąd stanu aplikacji');
      }
    }

    _syncPeopleEvents();
    // if( people.isEmpty ) await seed();
  }


  /// creates [_peopleEvents] state from [_people]
  void _syncPeopleEvents(){
    if(!_fileManagers['people']!.fault){
      PeopleEvents.create(_peopleEvents, _people);
      notifyListeners();
    }
  }

  /// adds a message that is instantly displayed to the user by MyHomePage::userInfoSnackbar()
  void addUserMessage(String message)
  {
    userInfoMessages.clear();
    userInfoMessages.add(message);
    notifyListeners();
  }


  void clearUserMessages()
  {
    userInfoMessages.clear();
    notifyListeners();
  }


  /// adds person via PeopleJsonFileManager and updates the AppState
  /// returns (isSuccess, reason)
  Future<OperationResult> addPerson(Person person) async {

    final OperationResult result = await _fileManagers['people']!.addItem(person);

    if ( result.isSuccess ) {
      PeopleEvents.create(_peopleEvents, _people);
      notifyListeners();
      return OperationResult(isSuccess: true);
    } else {
      notifyListeners();
      return OperationResult(reason: result.reason);
    }
  }


  Future<OperationResult> removePerson(String name) async {

    final OperationResult result = await _fileManagers['people']!.removeItem(name);

    if (result.isSuccess) {
      PeopleEvents.create(_peopleEvents, _people);
      notifyListeners();
      return OperationResult(isSuccess: true);
    } else {
      notifyListeners();
      return OperationResult(reason: result.reason);
    }
  }


  /// update person with given name as per given object
  Future<OperationResult> updatePerson(String personName, Person newPersonData) async {

    var idx = _people.indexWhere((x)=>x.name==newPersonData.name);

    // the name user wanna change to already exists?
    if(personName!=newPersonData.name && idx!=-1)
    {
      return OperationResult(reason:'osoba już istnieje');
    }

    var personCopy = _getPersonDeepCopy(_people.firstWhere((p)=>p.name==personName));

    _people.removeWhere((p)=>p.name==personName);
    _people.add(newPersonData);

    var result = await _fileManagers['people']!.saveItems();

    if ( result.isSuccess ) {
      PeopleEvents.create(_peopleEvents, _people);
      notifyListeners();
      return OperationResult(isSuccess: true);
    } else {
      // revert changes
      _people.removeWhere((p)=>p.name==newPersonData.name);
      _people.add(personCopy);
      notifyListeners();
      return OperationResult(reason:'problem z zapisem');
    }
  }


  /// TODO move this method to Person static
  Person _getPersonDeepCopy(Person personToCopy){
    return Person(
      name: personToCopy.name,
      birthday: personToCopy.birthday,
      nameday: personToCopy.nameday==null ?
        null : DayMonth(personToCopy.nameday!.day, personToCopy.nameday!.month)
      );
  }

  /// delegates save app state backup to JSON file in user selected directory
  /// TODO app states backup
  Future<bool> saveBackup(String dir) async{
    
    return await (_fileManagers['people'] as PeopleFileManager).backup(dir);
  }

  /// read app state backup from user selected JSON file
  /// and overwrites app state file with read data
  /// TODO app states backup
  Future<bool> restoreBackup(String filePath) async{
    var isSuccess = await (_fileManagers['people'] as PeopleFileManager).restoreBackup(filePath);
    if ( isSuccess ) {
      PeopleEvents.create(_peopleEvents, _people);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  // Future<void> seed() async
  // {
  //   await addPerson(Person(name: 'Tomek Kolasa', birthday: DateTime(1981,12,27), nameday: DayMonth(29,12)));
  //   await addPerson(Person(name: 'Agnieszka Krawczyk', birthday: DateTime(1985,4,15)));
  //   await addPerson(Person(name: 'Dominik Krawczyk', birthday: DateTime(2012,4,25)));
  // }
}