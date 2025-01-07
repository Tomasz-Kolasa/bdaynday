import 'package:urodziny_imieniny/utils/date_time_extenstion.dart';

  /// Returns Event Day in given year with DD-MM BEFORE today's DD-MM
  /// means that Event passed this year
  /// EventCalculator uses DateTimeExtenstion.today() as a starting point
  /// so test data is dynamic
  DateTime eventDayMonthBeforeToday({int year=2000})
  {
    var today = DateTimeExtenstion.today();

    if(today.day==1 && today.month==1)
    {
      throw Exception('Can create date earlier than 01.01 this year!');
    }

    var yesterday = today.subtract(Duration(days: 1));

    return yesterday;
  }

  /// Returns Event Day in given year with DD-MM AFTER today's DD-MM
  /// means that Event is coming this year
  /// EventCalculator uses DateTimeExtenstion.today() as a starting point
  /// so test data is dynamic
  DateTime eventDayMontAfterToday({int year=2000})
  {
    var today = DateTimeExtenstion.today();

    if(today.day==31 && today.month==12)
    {
      throw Exception('Can create date later than 31.12 this year!');
    }

    var tomorrow = today.add(Duration(days: 1));

    return tomorrow;
  }

  /// Returns Event Day in given year DD-MM as it is today
  /// means that Event is today
  /// EventCalculator uses DateTimeExtenstion.today() as a starting point
  /// so test data is dynamic
  DateTime eventDayMonthToday({int year=2000})
  {
    var today = DateTimeExtenstion.today();
    _checkIfDateIsValid(year, today.month, today.day);
    return DateTime(year, today.month, today.day);
  }

  void _checkIfDateIsValid(int year, int month, int day)
  {
    var mm = (month<10) ? '0$month' : month;
    var dd = (day<10) ? '0$day' : day;

    try{
      DateTime.parse('$year-$mm-$dd');
    } catch(e)
    {
      throw ArgumentError('Couldn\'t create DateMonth: $year-$mm-$dd');
    }
  }