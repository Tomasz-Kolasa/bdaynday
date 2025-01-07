import 'package:flutter/material.dart';
import 'nav_bar_views/list_widgets/list_widget.dart';
import 'nav_bar_views/menu_widgets/menu_widget.dart';
import 'nav_bar_views/new_person_widgets/new_person_widget.dart';
import 'nav_bar_views/reminder_widgets/reminder_widget.dart';
import 'package:urodziny_imieniny/views/common_widgets/tab_headline.dart';
import 'package:urodziny_imieniny/views/common_widgets/app_view_widget.dart';
import 'package:provider/provider.dart';
import '../../states/my_app_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This class is the configuration for the state. It is stateful, meaning that it has a State object (defined below) that contains fields that affect how it looks.
  // It holds the values (in this case the title) provided by the parent (in this case the MyApp widget) and
  // used by the build method of the State. Fields in a Widget subclass are  always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 2;

  void _setDestinationIndex(int idx) {
    setState(() { // tells the Flutter there are changes in State so it buid() widget again
      selectedIndex=idx;
    });
  }

  @override
  Widget build(BuildContext context) { // rerun every time setState is called as it is State class

    final List<AppViewWidget> views = [
      MenuWidget(),
      ReminderWidget(),
      ListWidget(),
      NewPersonWidget()
      ];

    userInfoSnackbar(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Center(child: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
            )
          ),
      ),
      body: Column(
        children: [
      
          TabHeadline(headlineText: views[selectedIndex].title, icon: views[selectedIndex].icon,),
          views[selectedIndex],
      
          ],
        ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.menu), label: 'Menu'),
            NavigationDestination(icon: Icon(Icons.alarm), label: 'Przypomnij'),
            NavigationDestination(icon: Icon(Icons.list), label: 'Lista'),
            NavigationDestination(icon: Icon(Icons.person_add), label: 'Dodaj'),
          ],
          selectedIndex: selectedIndex,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          indicatorColor: Theme.of(context).colorScheme.inversePrimary,
          onDestinationSelected: (value) => _setDestinationIndex(value),
        ),
      ),
    );
  }


  /// snackbar instantly displaying user messages added by MyAppState::addUserMessage()
  void userInfoSnackbar(BuildContext context)
  {
    var appState = context.watch<MyAppState>();
    var messages = appState.userInfoMessages;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(messages.isNotEmpty)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: ListBody(children: [
            for(var m in messages) Text('$m.', style: TextStyle(fontSize: 16.0),)
          ],),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: Duration(seconds: 5),
          ),
        );
        messages.clear();
      }
    });
  }
}