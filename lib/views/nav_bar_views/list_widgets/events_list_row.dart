import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urodziny_imieniny/models/person_bday_nday.dart';

class EventsListRow extends StatelessWidget {
  const EventsListRow({
    super.key,
    required this.personEvent,
  });

  final PersonBdayNday personEvent;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        children: [
      
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Center(child: Icon(personEvent.getIcon(), size: 48)),
              ],
            ),
          ),
      
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          personEvent.name,
                          style: TextStyle(fontWeight:FontWeight.bold, fontSize: 18),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          ),
                      ),
                      ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Text(personEvent.getDescription())
                      ]
                    ),
                ),
              ],
            ),
          ),
      
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.hourglass_top),
                    ),
                    Text(personEvent.verbalDaysTo, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)],
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Text(DateFormat('dd-MM-yyy').format(personEvent.upcomingEventDate)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}