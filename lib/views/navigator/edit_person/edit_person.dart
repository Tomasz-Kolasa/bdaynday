import 'package:flutter/material.dart';
import 'package:urodziny_imieniny/views/common_widgets/person_form.dart';
import 'package:urodziny_imieniny/views/common_widgets/tab_headline.dart';
import 'package:urodziny_imieniny/states/my_app_state.dart';
import 'package:urodziny_imieniny/models/person.dart';
import 'package:provider/provider.dart';

class EditPerson extends StatelessWidget {

  final String personName;

  EditPerson({required this.personName});


  @override
  Widget build(BuildContext context) {

    Person? personToEdit;

    var appState = context.watch<MyAppState>();

    // if person 
    var idx = appState.people.indexWhere((x) => x.name==personName);
    if(idx>-1){
      personToEdit = appState.people[idx];
    } else {
      // person already edited and they name changed. widget has been rebuild so the name is not found
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('zmień dane'),
      ),
      body: Center(
        child: Column(
          children: [
            TabHeadline(headlineText: personName, icon: Icons.supervisor_account,),
          idx>-1?PersonForm(formCallback: updatePerson, personToEdit: personToEdit,):Expanded(child: Center(child: Text('nazwa zmieniona!'))),
        ],
        ),
      ),
    );
  }

  Future<bool> updatePerson(Person person, MyAppState appState) async
  {
    final result = await appState.updatePerson(personName, person);

    if(result.isSuccess)
    {
      appState.addUserMessage('uaktualniono');
      return true;
    } else{
      appState.addUserMessage(result.reason);
      return false;
    }
  }
}