import 'package:flutter/material.dart';

void dialog(BuildContext context, String messenge) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(messenge, style: TextStyle(fontSize: 20)),
        );
      });
}
