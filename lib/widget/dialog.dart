import 'package:flutter/material.dart';

void dialog(BuildContext context, String messenge, int state) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(
              messenge,
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            content: (state == 3
                ? Image.asset(
                    "assets/images/alert.png",
                    width: 100,
                    height: 100,
                  )
                : Image.asset(
                    (state == 0
                        ? "assets/images/Whitewins.png"
                        : (state == 1
                            ? "assets/images/Blackwins.png"
                            : "assets/images/Draw.png")),
                    width: 150,
                    height: 150,
                  )));
      });
}
