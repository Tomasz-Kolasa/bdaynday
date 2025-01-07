import 'package:flutter/material.dart';

mixin ConfirmationDialog{
  Future<bool?> showConfirmationDialog(BuildContext context, {String message='Na pewno?'}) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Potwierdź'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No action
              },
              child: Text('Nie'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes action
              },
              child: Text('Tak'),
            ),
          ],
        );
      },
    );
  }
}