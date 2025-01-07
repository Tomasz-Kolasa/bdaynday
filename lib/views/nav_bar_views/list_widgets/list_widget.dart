import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urodziny_imieniny/states/my_app_state.dart';
import 'package:urodziny_imieniny/views/nav_bar_views/list_widgets/events_list_row.dart';
import 'package:urodziny_imieniny/views/common_widgets/app_view_widget.dart';
import 'package:urodziny_imieniny/views/navigator/edit_person/edit_person.dart';
import 'package:urodziny_imieniny/utils/confirmation_dialog.dart';

class ListWidget extends StatelessWidget with ConfirmationDialog implements AppViewWidget{
  const ListWidget({
    super.key,
  });

  @override
  final String title = 'nadchodzące wydarzenia';

  @override
  IconData get icon => Icons.celebration;

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<MyAppState>();

    return Expanded(
      child: Column(
        children: <Widget>[
            appState.peopleEvents.isEmpty
            ?
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Pusto tutaj, dodaj swoich bliskich!'),
              ],
            ))
            :
            Expanded(
              child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: appState.peopleEvents.length,

              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                key: Key(appState.peopleEvents[index].name),
                  background: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.errorContainer,
                      ),
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction){
                    return showConfirmationDialog(context, message: 'Na pewno usunąć?');
                  },
                  onDismissed: (direction) {
                    _removePerson(appState.peopleEvents[index].name, appState);
                  },
                  child: GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditPerson(personName: appState.peopleEvents[index].name)),
                    );
                  },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        color: appState.peopleEvents[index].getColor(Theme.of(context).colorScheme),
                        child: EventsListRow(personEvent: appState.peopleEvents[index])
                      ),
                    ),
                  ),
                );
              }
            )
          )
        ],
      ),
    );
  }

  Future<void> _removePerson(String name, MyAppState appState) async{
    final result = await appState.removePerson(name);
    if(result.isSuccess){
      appState.addUserMessage("Usunięto $name");
    } else {
      appState.addUserMessage(result.reason);
    }
  }
}