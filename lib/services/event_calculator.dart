import 'package:urodziny_imieniny/models/day_month.dart';
import 'package:urodziny_imieniny/models/person.dart';
import '../models/person_bday_nday.dart';
import 'package:urodziny_imieniny/utils/date_time_extenstion.dart';

/// This class is responsible for calculation of:
/// 1) Upcoming Event date
/// 2) Days remaining to event
/// Returns list containing PersonBday and PersonNday(if specified in given Person object)
/// that can be displayed by ListWidget
/// It contains the entire logic of event day calculation.
/// Includes scenario, where event date is 29 of Feb. In this case it has to be decided on which day
/// of non-leap year the event will be placed. e.g. 28th Feb or 1st March
/// so upcomingEventDate also is computed.
class EventCalculator{

  final Person person;

  EventCalculator(this.person);

  /// Calculates the closest birthday or nameday(if specified) day, creates PersonBday and PersonNday respectively
  /// and returns a list containing one or both objects
  /// also calculates other values, like days to event (for details see _computedBday() and _computedNday())
  List<PersonBdayNday> computeEvents()
  {
    var eventsComputed = <PersonBdayNday>[];

    eventsComputed.add(_computedBday());

    var personNday = _computedNday();
    if(personNday != null)
    {
      eventsComputed.add(personNday);
    }

    return eventsComputed;
  }

  /// compute: upcomingEventDate, isEventDateMoved, daysTo for PersonBday
  PersonBday _computedBday()
  {
    // determinate upcomingEventDate, i.e. the clostest birthday
    var bday = person.birthday;

    var (upcomingEventDate, isEventDateMoved) = _computeUpcomingEventDate(DayMonth(bday.day, bday.month));
    var daysTo = _computeDaysTo(upcomingEventDate);
    var turns = _getTurns(upcomingEventDate, bday);
    
    return PersonBday(person.name, daysTo, upcomingEventDate, isEventDateMoved, turns);
  }

  /// compute: upcomingEventDate, isEventDateMoved, daysTo for PersonNday
  PersonNday? _computedNday()
  {
    var nday = person.nameday;

    if(nday == null) return null;

    var (upcomingEventDate, isEventDateMoved) = _computeUpcomingEventDate(nday);
    var daysTo = _computeDaysTo(upcomingEventDate);
    
    return PersonNday(person.name, daysTo, upcomingEventDate, isEventDateMoved);
  }

  /// calculate birthday number to display 'turns 37' information like
  int _getTurns(DateTime upcomingEventDate, DateTime bday)
  {
    return upcomingEventDate.year - bday.year;
  }

  /// Decides substitution date for leap year event, i.e. event on 29th Feb
  /// eg. Person birthday on Feb 29. will be celebrated on Feb 28
  DayMonth _getSubstituteDate()
  {
    // one day before
    return DayMonth(28, DateTime.february);
  }


  /// Calculates and return (upcomingEventDate, isEventDateMoved) based on given event day
  (DateTime, bool) _computeUpcomingEventDate(DayMonth evDate)
  {
    late (DateTime, bool) closestEventComputed;
    var now = DateTimeExtenstion.today();

    if(_isLeapYearEvent(daymonth: evDate)) // 29th Feb bday
    {
      if(DateTimeExtenstion.isLeapYear(now.year))
      {
        if(now.month<DateTime.march) // up to 29th Feb
        {
          closestEventComputed = (DateTime(now.year, evDate.month, evDate.day), false);
        }
        else
        {
          var substituteDate = _getSubstituteDate();
          closestEventComputed = (_computeUpcomingEventFromNonLeapDate(substituteDate), true);
        }
      }
      else // 29th Feb bday in non-leap year
      {
        var now = DateTimeExtenstion.today();
        var substituteDate = _getSubstituteDate();

        if(_isEventMissedNow(DateTime(now.year, substituteDate.month, substituteDate.day)))
        {
          if(DateTimeExtenstion.isLeapYear(now.year+1))
          {
            // next year 29th 
            closestEventComputed = (DateTime(now.year+1, evDate.month, evDate.day), false);
          }
          else
          {
            // this year substitute day
            closestEventComputed = (_computeUpcomingEventFromNonLeapDate(substituteDate), true);
          }
        }
        else  // substitution event day not missed
        {
          closestEventComputed = (_computeUpcomingEventFromNonLeapDate(substituteDate), true);
        }
      }
    }
    else // not a leap year event
    {
      var now = DateTimeExtenstion.today();

      if(_isEventMissedNow(DateTime(now.year, evDate.month, evDate.day)))
      {
        closestEventComputed = (DateTime(now.year+1, evDate.month, evDate.day), false);
      }
      else  // substitution event day not missed
      {
        closestEventComputed = (_computeUpcomingEventFromNonLeapDate(DayMonth(evDate.day, evDate.month)), false);
      }
    }

    return closestEventComputed;
  }

  /// chcheck if given event was earlier than now
  /// returns true if days difference is less than 0
  bool _isEventMissedNow(DateTime eventDate)
  {
    var now = DateTimeExtenstion.today();
    var daysDiff = now.difference(eventDate).inDays;

    return (daysDiff>0) ? true:false;
  }

  /// Calculates the closest upcoming event from a DayMonth other than 29th Feb
  DateTime _computeUpcomingEventFromNonLeapDate(DayMonth nonLeapYearDate)
  {
    if(_isLeapYearEvent(daymonth: nonLeapYearDate))
    {
      throw ArgumentError('Parameter dayMonth must not be 29th Febuary here!');
    }

    late DateTime result;

    var now = DateTimeExtenstion.today();
    var thisYearEventDate = DateTime(now.year, nonLeapYearDate.month, nonLeapYearDate.day);

    if(_isEventMissedNow(thisYearEventDate)) // event day passed this year
    {
      result = DateTime(now.year+1, nonLeapYearDate.month, nonLeapYearDate.day);
    }
    else // event day today or later this year
    {
      result = DateTime(now.year, nonLeapYearDate.month, nonLeapYearDate.day);
    }

    return result;
  }

  /// Check if given [datetime] or [daymonth] happens to be a leapyear event
  /// i.e. it happens to be on Feb 29.
  /// in case of two arguments passed returns true if any of the two is a leapear event
  bool _isLeapYearEvent({DateTime? datetime, DayMonth? daymonth})
  {
    if(datetime != null && datetime.month==DateTime.february && datetime.day==29)
    {
      return true;
    }

    if(daymonth != null && daymonth.month==DateTime.february && daymonth.day==29)
    {
      return true;
    }

    return false;
  }

  /// compute days to computed upcomingEventDate from now
  /// DateTime [upcomingEventDate] must not be leap event date
  /// NOTE: at this point event day is in the future
  int _computeDaysTo(DateTime upcomingEventDate)
  {
    if(_isLeapYearEvent(datetime:upcomingEventDate))
    {
      throw ArgumentError('upcomingEventDate must not be leap event!');
    }

    var today = DateTimeExtenstion.today();
    var diff = upcomingEventDate.difference(today).inDays;

    return diff;
  }
}