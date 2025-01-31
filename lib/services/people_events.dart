import '../models/person.dart';
import 'package:urodziny_imieniny/models/person_bday_nday.dart';
import 'event_calculator.dart';

/// This is used to create and update the PersonBdayNday[] (app state variable)
/// It splits Person[] (app state variable) into PersonBday and PersonNday objects
/// Also computes days to events using DaysToEventCalculator
class PeopleEvents{

  /// create the <PersonBdayNday>[] (app state variable)
  /// IMPORTANT: this method expects the list to be empty so it clears it just in case
  static void create(List<PersonBdayNday> bdaysNdays, List<Person> people)
  {
    bdaysNdays.clear();

    for(var person in people)
    {
      _addPerson(bdaysNdays, person);
    }

    bdaysNdays.sort((a, b) => a.daysTo.compareTo(b.daysTo));
  }

  /// Add a [person] to [bdaysNdays] list
  /// delegate method
  static add(List<PersonBdayNday> bdaysNdays, Person person)
  {
    _addPerson(bdaysNdays,person);
  }

  static remove(List<PersonBdayNday> bdaysNdays, Person person)
  {
    bdaysNdays.removeWhere((x)=>x.name==person.name);
  }

  /// Add a [person] to [bdaysNdays] list
  static void _addPerson(List<PersonBdayNday> bdaysNdays, Person person)
  {
    bdaysNdays.addAll(EventCalculator(person).computeEvents());
  }
}