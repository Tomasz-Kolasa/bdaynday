import 'package:urodziny_imieniny/models/day_month.dart';

abstract class JsonSerializeable{

  JsonSerializeable();

  Map<String, dynamic> toJson();
}

/// Data Model class
/// Represents a person, contains all informations like [name], [birthday], optional [nameday]
class Person extends JsonSerializeable{
  String name;
  DateTime birthday;
  final DayMonth? nameday;

  Person({
    required this.name,
    required this.birthday,
    this.nameday
  });


  factory Person.fromJson(Map<String, dynamic> json){
      return Person(
        name: json['name'],
        birthday: DateTime.parse(json['birthday']), // from ISO 8601
        nameday: json['nameday'] != null ? DayMonth.fromJson(json['nameday']) : null,
      );
  }


  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthday': birthday.toIso8601String(),
      'nameday': nameday?.toJson(),
    };
  }
}