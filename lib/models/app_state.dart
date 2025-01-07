import './person.dart';
import './notif.dart';
import 'dart:core';

class AppState{
  late List<Person> people;
  late List<Notif> notif;

  AppState(){
    people = List<Person>.empty();
    notif = List<Notif>.empty();
  }
}