import 'package:urodziny_imieniny/models/day_month.dart';

class DateTimeExtenstion
{

  /// returns today with hh:mm:ss set to 0
  static DateTime today()
  {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// returns tomorrow with hh:mm:ss set to 0
  static DateTime tomorrow()
  {
    return today().add(Duration(days: 1));
  }

  /// returns yesterday with hh:mm:ss set to 0
  static DateTime yesterday()
  {
    return today().subtract(Duration(days: 1));
  }

  /// returns closest DateTime from DayMonth
  /// if this year can't be created returns last year
  static DateTime dateTimeFromDayMonth(DayMonth date)
  {
    var now = DateTime.now();

    var year = (date.day==29 && date.month==2 && !isLeapYear(now.year-1)) ? now.year-2:now.year-1;
    {
      return DateTime(year, date.month, date.day);
    }
  }

  static bool isLeapYear(int year)
  {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}