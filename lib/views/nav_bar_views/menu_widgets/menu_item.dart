import 'package:flutter/material.dart';
import 'package:urodziny_imieniny/services/menu_item_handlers/menu_item_handler.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.handler
  });

  final IconData icon;
  final String text;
  final MenuItemHandler handler;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handler.handleMenuItem,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(icon, size: 48),
            ),
            Text(
              style: TextStyle(fontSize: 18.0),
              text,
            ),
          ],
        ),
      ),
    );
  }
}