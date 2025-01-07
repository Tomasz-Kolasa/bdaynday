import 'package:urodziny_imieniny/services/event_calculator.dart';
import 'package:urodziny_imieniny/models/person.dart';
import 'package:urodziny_imieniny/models/person_bday_nday.dart';
import 'package:urodziny_imieniny/utils/date_time_extenstion.dart';
import './input_generators.dart';
import 'package:test/test.dart';

void main() {

  // The purpose of tests is to check calculations of:
  // 1) Upcoming Event date, e.g. when is the closest birthday?
  // 2) Days remaining to event, e.g. in how many days will be birthday


  group('Test birthday calculations, no nameday specified, bday passed this year', (){

    // INPUTS
    var now = DateTimeExtenstion.today();
    var input = eventDayMonthBeforeToday();

    var perosn = Person(
      name: 'Tomek',
      birthday: input
      );

    final ec = EventCalculator(perosn);

    // EXECUTE
    var bdayNday = ec.computeEvents();


    // ASSERTS
    test('list should contain only PersonBday', (){
      expect(bdayNday.length, 1);
      expect(bdayNday[0], isA<PersonBday>());
    });

    test('calc bDay UpcomingEventDate when bday passed this year', (){
      expect(bdayNday[0].upcomingEventDate, DateTime(now.year+1, input.month, input.day));
    });

    test('calc daysTo', ()=>{
      expect(bdayNday[0].daysTo,
        DateTime(now.year+1, input.month, input.day).difference(now).inDays)
    });

    test('isEventDateMoved should be false', (){
      expect(bdayNday[0].isEventDateMoved, false);
    });
  });


  group('Test birthday calculations, no nameday specified, bday coming this year', (){
        // INPUTS
    var now = DateTimeExtenstion.today();
    var input = eventDayMontAfterToday();

    var perosn = Person(
      name: 'Tomek',
      birthday: input
      );

    final ec = EventCalculator(perosn);

    // EXECUTE
    var bdayNday = ec.computeEvents();


    // ASSERTS
    test('list should contain only PersonBday', (){
      expect(bdayNday.length, 1);
      expect(bdayNday[0], isA<PersonBday>());
    });

    test('calc bDay UpcomingEventDate when bday coming this year', (){
      expect(bdayNday[0].upcomingEventDate, DateTime(now.year, input.month, input.day));
    });

    test('calc daysTo', ()=>{
      expect(bdayNday[0].daysTo,1)
    });

    test('isEventDateMoved should be false', (){
      expect(bdayNday[0].isEventDateMoved, false);
    });
  });


  group('Test birthday calculations, no nameday specified, bday is today', (){
        // INPUTS
    var now = DateTimeExtenstion.today();
    var input = eventDayMonthToday();

    var perosn = Person(
      name: 'Tomek',
      birthday: input
      );

    final ec = EventCalculator(perosn);

    // EXECUTE
    var bdayNday = ec.computeEvents();


    // ASSERTS
    test('list should contain only PersonBday', (){
      expect(bdayNday.length, 1);
      expect(bdayNday[0], isA<PersonBday>());
    });

    test('calc bDay UpcomingEventDate when event today', (){
      expect(bdayNday[0].upcomingEventDate, DateTime(now.year, input.month, input.day));
    });

    test('calc daysTo', ()=>{
      expect(bdayNday[0].daysTo, 0)
    });

    test('isEventDateMoved should be false', (){
      expect(bdayNday[0].isEventDateMoved, false);
    });
  });

  group('leap year bday', (){
    test('leap bday passed', (){
      // INPUT
      var person = Person(name: 'Tomasz Kolasa', birthday: DateTime(2020,2,29));
      var today = DateTimeExtenstion.today();

      // EXECUTE
      var ec = EventCalculator(person);
      var output = ec.computeEvents();

      // ASSERTS
      expect(output[0].upcomingEventDate, DateTime(2025,2,28));
      expect(output[0].daysTo, DateTime(2025,2,28).difference(today).inDays);
    });
  });
}

