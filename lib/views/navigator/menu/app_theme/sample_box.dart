import 'package:flutter/material.dart';

class SampleBox extends StatelessWidget{

  final Color color;

  SampleBox({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
              height: 100,
              color: color,
            ),
    );
  }
}