import 'package:flutter/material.dart';
import 'package:urodziny_imieniny/types/operation_result.dart';
import 'package:urodziny_imieniny/views/common_widgets/person_form.dart';
import 'package:urodziny_imieniny/views/common_widgets/app_view_widget.dart';
import 'package:urodziny_imieniny/states/my_app_state.dart';
import 'package:urodziny_imieniny/models/person.dart';

class NewPersonWidget extends StatefulWidget implements AppViewWidget{
  const NewPersonWidget({
    super.key,
  });

  @override
  final String title = 'dodaj osobę';

  @override
  State<NewPersonWidget> createState() => _NewPersonWidgetState();
  
  @override
  IconData get icon => Icons.person_add;
}

class _NewPersonWidgetState extends State<NewPersonWidget> {

  // DateTime? birthday;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              PersonForm(formCallback: addPerson),
            ],
          ),
        ),
      ),
    );
  }


  Future<bool> addPerson(Person person, MyAppState appState) async
  {
    final OperationResult result = await appState.addPerson(person);

    if(result.isSuccess)
    {
      appState.addUserMessage('Osoba dodana');
      return true;
    } else{
      appState.addUserMessage(result.reason);
      return false;
    }
  }
}

