import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chess_app/widget/validator.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

showAlertDialog(BuildContext context, String result) {
  // set up the buttons
  Widget chessButton = TextButton(
    child: Text("Watch chessboard"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget rematchButton = TextButton(
    child: Text("Exit"),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/online_chess');
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Game Over"),
    content: Text(result),
    actions: [
      chessButton,
      rematchButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class OnlineWatchScreen extends StatefulWidget {
  @override
  _OnlineWatchScreenState createState() => _OnlineWatchScreenState();
}

class _OnlineWatchScreenState extends State<OnlineWatchScreen> with Validator {
  final TextEditingController _roomIdController = TextEditingController();
  final ChessBoardController controller = new ChessBoardController();
  final double minValue = 8.0;
  final _formKey = GlobalKey<FormState>();
  String roomId = "";
  int screen = 0;
  String turn = "";
  String fen = "";
  String player1 = "";
  String player2 = "";
  bool createWhite = true;

  int experienceIndex = 0;

  final TextStyle _errorStyle = TextStyle(
    color: Colors.red,
    fontSize: 16.6,
  );

  @override
  void initState() {
    super.initState();
    screen = 0;
    turn = "white";
    fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
    player1 = "";
    player2 = "";
    createWhite = true;
  }

  void dialog(String messenge) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Text(messenge, style: TextStyle(fontSize: 20)),
          );
        });
  }

  Widget formRoomID() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: minValue * 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: minValue, vertical: minValue),
                      child: TextFormField(
                        controller: _roomIdController,
                        keyboardType: TextInputType.text,
                        maxLines: 2,
                        validator: roomIdValidator,
                        decoration: InputDecoration(
                            errorStyle: _errorStyle,
                            border: InputBorder.none,
                            labelText: 'Room ID',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: minValue),
                            labelStyle: TextStyle(
                                fontSize: 16.0, color: Colors.black87)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: minValue * 6,
                  ),
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(horizontal: minValue * 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          colors: [Colors.pink[700], Colors.pink[400]]),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Processing Room ID')));
                          var inputRoomId = _roomIdController.text;
                          databaseReference
                              .child("$inputRoomId")
                              .once()
                              .then((snapshot) {
                            if (snapshot.value == null) {
                              dialog(
                                  "Room ID $inputRoomId has not been created yet");
                            } else if (snapshot.value["start"] == false) {
                              dialog(
                                  "Room ID $inputRoomId has not started yet. You cannot join as spectator. But you can join it.");
                            } else {
                              roomId = inputRoomId;
                              Future.delayed(const Duration(seconds: 1))
                                  .then((value) {
                                controller.game.load(snapshot.value["fen"]);
                                controller.refreshBoard();
                              });
                              FirebaseDatabase.instance
                                  .reference()
                                  .child("$roomId")
                                  .onValue
                                  .listen((event) {
                                fen = event.snapshot.value['fen'];
                                Future.delayed(const Duration(seconds: 1))
                                    .then((value) {
                                  controller.game.load(fen);
                                  controller.refreshBoard();
                                });
                              });
                              setState(() {
                                player1 = snapshot.value['name_1'];
                                player2 = snapshot.value['name_2'];
                                createWhite = snapshot.value['create_white'];
                                screen = 1;
                              });
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: minValue * 2.4),
                        elevation: 0.0,
                        primary: Colors.transparent,
                      ),
                      child: Text('Watch'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget chessBoard() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              "Room ID: $roomId",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, bottom: 5.0, top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlackKing(
                  size: MediaQuery.of(context).size.width * 0.1,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text((createWhite ? player2 : player1),
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: ChessBoard(
                size: MediaQuery.of(context).size.width * 0.9,
                onDraw: () {
                  showAlertDialog(context, "Draw");
                },
                onCheckMate: (loser) {
                  if (loser == PieceColor.Black) {
                    showAlertDialog(context, "Checkmate. White wins");
                  } else {
                    showAlertDialog(context, "Checkmate. Black wins");
                  }
                },
                onMove: (move) {
                  print("Hello Bitch!");
                },
                onCheck: (color) {},
                chessBoardController: controller,
                enableUserMoves: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WhiteKing(
                  size: MediaQuery.of(context).size.width * 0.1,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text((createWhite ? player1 : player2),
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Watch Chess Room"),
      ),
      body: Container(
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomCenter, colors: [
            Colors.white.withOpacity(0.6),
            Colors.white.withOpacity(0.5)
          ])),
          child: (screen == 0 ? formRoomID() : chessBoard()),
        ),
      ),
    );
  }
}
