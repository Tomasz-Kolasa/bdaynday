import 'package:flutter/material.dart';

class TabHeadline extends StatelessWidget {
  const TabHeadline({
    super.key,
    required this.headlineText,
    required this.icon
  });

  final String headlineText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, color: Theme.of(context).colorScheme.primaryContainer, size: 36.0,),
          ),
          Text(headlineText, style: TextStyle(
            color: Theme.of(context).colorScheme.primaryContainer,
            fontSize: 16.0
            ),
          ),
        ],
      ),
    );
  }
}