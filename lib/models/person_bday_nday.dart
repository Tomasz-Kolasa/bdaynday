import 'package:flutter/material.dart';

/// Data Model class
/// Abstract class used as a base for PersonBday and PersonNday classes
/// In order to split Person object containing all person data
/// into two speratate objects types that are then displayed as Birthday and Nameday
abstract class PersonBdayNday
{
  /// person name
  final String name;

  /// computed days to upcomingEventDate
  final int daysTo;

  /// computed upcoming event date, which is the closest bday or nameday
  final DateTime upcomingEventDate;

  /// Idicates wheter original event date is moved to other date, e.g. due to leap year
  final bool isEventDateMoved;

  PersonBdayNday(this.name, this.daysTo, this.upcomingEventDate, this.isEventDateMoved);

  /// verbal description of [daysTo]
  /// eg. im case 0 [daysTo] would be something like 'Today'
  /// default value will be [daysTo].toString()
  String get verbalDaysTo {
    return switch (daysTo) {
      0 => 'dzisiaj',
      1 => 'jutro',
      2 => 'pojutrze',
      _  => '$daysTo dni',
    };
  }

  /// Color based on current [colorScheme] that will be used when creating list row for this event
  Color getColor(ColorScheme colorScheme);

  /// Icon for this event
  IconData getIcon();

  /// Description of this event, e.g. '40. birthday' or 'nameday'
  String getDescription();
}


/// Data Model class
/// Birthday List Item
/// DateTime [upcomingEventDate] DaysToEventCalculator computed DateTime of upcoming birthday (yes, it must me calculated due to leap year)
class PersonBday extends PersonBdayNday
{

  /// eg. today turns 40
  final int turns;

  PersonBday(
    super.name, super.daysTo, super.upcomingEventDate, super.isEventDateMoved, this.turns
    );

  /// Color based on current [colorScheme] that will be used when creating list row for this event
  @override
  Color getColor(ColorScheme colorScheme)
  {
    return colorScheme.inversePrimary;
  }

  /// Icon for this event
  @override
  IconData getIcon()
  {
    return Icons.cake;
  }

  /// Description of this event, e.g. '40. birthday' or 'nameday'
  @override
  String getDescription()
  {
    return '$turns. urodziny';
  }
}


/// Data Model class
/// Nameday List Item
/// DateTime [upcomingEventDate] DaysToEventCalculator computed DayMonth of upcoming nameday (yes, it must me calculated due to leap year)
class PersonNday extends PersonBdayNday
{
  PersonNday(super.name, super.daysTo, super.upcomingEventDate, super.isEventDateMoved);

  /// Color based on current [colorScheme] that will be used when creating list row for this event
  @override
  Color getColor(ColorScheme colorScheme)
  {
    return colorScheme.primaryContainer;
  }

  /// Icon for this event
  @override
  IconData getIcon()
  {
    return Icons.card_giftcard;
  }

  /// Description of this event, e.g. '40. birthday' or 'nameday'
  @override
  String getDescription()
  {
    return 'Imieniny';
  }
}