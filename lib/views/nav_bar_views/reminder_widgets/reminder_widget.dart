import 'package:flutter/material.dart';
import 'package:urodziny_imieniny/views/common_widgets/app_view_widget.dart';

class ReminderWidget extends StatefulWidget implements AppViewWidget {
  const ReminderWidget({
    super.key,
  });
  @override
  final String title = 'przypomnienia';

  @override
  IconData get icon => Icons.alarm;

  @override
  State<ReminderWidget> createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {

  int? _weeks, _days, _hour, _min;

  final List<int> _weeksRange = List.generate(12, (index)=>index+1);
  final List<int> _daysRange = List.generate(7, (index)=>index+1);
  final List<int> _hourRange = List.generate(24, (index)=>index+1);
  final List<int> _minRange = List.generate(60, (index)=>index+1);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'wybierz ile czasu przed wydarzeniem przypomnieć',
            ),

            DropdownButton<int>(
                  hint: Text('tygodnie'),
                  value: _weeks,
                  onChanged: (int? newValue) {
                    setState(() {
                      _weeks = newValue;
                    });
                  },
                  items: _weeksRange.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                )

          ],
        ),
    );
  }
}