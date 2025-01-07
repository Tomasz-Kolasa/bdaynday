import 'package:flutter/material.dart';
import 'package:urodziny_imieniny/states/my_app_state.dart';
import 'package:provider/provider.dart';

abstract class MenuItemHandler{

  late MyAppState appState;

  MenuItemHandler(this.context){
    appState = Provider.of<MyAppState>(context, listen: false);
  }

  final BuildContext context;

  void handleMenuItem();
}