import 'package:flutter/material.dart';

class CircleStatus extends StatefulWidget {
  CircleStatus({@required Key key}) : super(key: key);
  @override
  CircleStatusState createState() => CircleStatusState();
}

class CircleStatusState extends State<CircleStatus> {
  int turn; // = 0 pause, = 1 resume

  @override
  void initState() {
    super.initState();
    turn = 0;
  }

  void changeTurn(int newTurn) {
    setState(() {
      turn = newTurn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: (turn == 1
          ? BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            )
          : BoxDecoration()),
    );
  }
}
