import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urodziny_imieniny/models/day_month.dart';
import 'package:urodziny_imieniny/states/my_app_state.dart';
import 'package:urodziny_imieniny/models/person.dart';
import 'package:urodziny_imieniny/utils/date_time_extenstion.dart';

class PersonForm extends StatefulWidget {

  final Person? personToEdit;
  final Function(Person person, MyAppState appState) formCallback;

  const PersonForm({
    super.key,
    required this.formCallback,
    this.personToEdit
  });

  @override
  State<PersonForm> createState() => _PersonFormState();
}


class _PersonFormState extends State<PersonForm> {

  Person? _personToEdit;

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  late DateTime _bday;
  DateTime? _nday;

  @override
  void initState(){
    super.initState();
    _personToEdit = widget.personToEdit;
    _bday = _getInitialBday();
    _nday = _getInitialNday();
  }


  Future<void> _pickBdayDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'Data urodzin',
      initialDate: _bday,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pl', 'PL'),
    );
    if (pickedDate != null) {
      setState(() {
        _bday = pickedDate;
      });
    }
  }

  Future<void> _pickNdayDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      helpText: 'Data imienin (rok nie ma znaczenia)',
      initialDate: _nday ?? DateTime( DateTime.now().year-1, 6, 1 ),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pl', 'PL'),
    );

    setState(() {
      _nday = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<MyAppState>();

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: _personToEdit?.name,
              maxLength: 25,
              decoration: InputDecoration(
                labelText: 'wprowadź nazwę',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                setState(() {
                  _name = value!.trim();
                });
              },
              validator: (value) {
                final allowedCharacters = RegExp(r'^[a-zA-Z0-9ąćęłńóśźżĄĆĘŁŃÓŚŹŻ ]+$');

                if (value == null || value.isEmpty ) {
                  return 'to pole nie może być puste';
                } else if(value.trim().isEmpty){
                  return 'nazwa nie może mieć samych spacji';
                } else if(value.trim().length>30){
                  return 'nazwa jest za długa';
                } else if(!allowedCharacters.hasMatch(value.trim())){
                  return 'tylko litery, cyfry i spacja';
                }else{
                  return null;
                }
              },
            ),

            Row(children: [Text('data urodzin')],),

            Row( // bday
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            width: 1.0
                            )
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          DateFormat('dd-MM-yyy').format(_bday),
                          textAlign: TextAlign.center
                          )
                        )
                    ],
                    )
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      ElevatedButton(onPressed: _pickBdayDate, child: Icon(Icons.edit_calendar))
                    ],
                    )
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(children: [Text('data imienin')],),
            ),

            Row( // nday
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            width: 1.0
                            )
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Text( _nday==null ? 'brak':
                          DateFormat('dd-MM-yyy').format(_nday!),
                          textAlign: TextAlign.center
                          )
                        )
                    ],
                    )
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      ElevatedButton(onPressed: _pickNdayDate, child: Icon(Icons.edit_calendar))
                    ],
                    )
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      ElevatedButton(onPressed: ()=>{
                        setState(() {
                          _nday=null;
                        })
                      }, child: Icon(Icons.clear))
                    ],
                    )
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save(); // triggers onSaved callbacks of form fields
                    var person = Person(
                      name: _name,
                      birthday: _bday,
                      nameday: _nday==null ? null : DayMonth(_nday!.day, _nday!.month)
                    );
              
                    informParentWidget(person, appState);
                  }
                  else
                  {
                    appState.addUserMessage('popraw dane');
                  }
                },
                child: Text('Zapisz'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> informParentWidget(Person person, MyAppState appState) async{
    var success = await widget.formCallback(person, appState);
    if(success){
      _formKey.currentState!.reset();
      _resetBdayNday();
    }
  }

  /// reset to initial values
  void _resetBdayNday(){
    _bday = _getInitialBday();
    _nday = _getInitialNday();
  }

  /// from initial birthday in case:
  /// 1) add new person
  /// 2) edit person
  DateTime _getInitialBday(){
    return _personToEdit != null ? _personToEdit!.birthday
     : DateTimeExtenstion.today().subtract(Duration(days:20*365));
  }

  /// from initial birthday in case:
  /// 1) add new person
  /// 2) edit person
  DateTime? _getInitialNday(){
    return (_personToEdit!=null && _personToEdit?.nameday != null) ? 
      DateTimeExtenstion.dateTimeFromDayMonth(_personToEdit!.nameday!) : null;
  }
}