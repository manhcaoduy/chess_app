import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chess_app/widget/validator.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

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
  bool isGameOver = false;
  String endgameMessenge = '';

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

  void dialog(BuildContext context, String messenge) {
    showDialog(
        context: context,
        builder: (context) {
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
                        style: TextStyle(color: Colors.black),
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
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            )),
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
                              dialog(context,
                                  "Room ID $inputRoomId has not been created yet");
                            } else if (snapshot.value["start"] == false) {
                              dialog(context,
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
                                var isGameOverDb =
                                    event.snapshot.value['gameover'];
                                var endgameMessengeDb =
                                    event.snapshot.value['endgame_status'];
                                Future.delayed(const Duration(seconds: 1))
                                    .then((value) {
                                  controller.game.load(fen);
                                  controller.refreshBoard();
                                });
                                if (isGameOverDb) {
                                  dialog(context, endgameMessengeDb);
                                  setState(() {
                                    isGameOver = true;
                                    endgameMessenge = endgameMessengeDb;
                                  });
                                }
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
              (isGameOver ? endgameMessenge : "Room ID: $roomId"),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Image.asset(
                        (createWhite
                            ? "assets/images/garry_kasparov.jpg"
                            : "assets/images/magnus_carlsen.jpeg"),
                        width: 70,
                        height: 70,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text((createWhite ? player2 : player1),
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ChessBoard(
                    size: (MediaQuery.of(context).size.height > 700
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.width * 0.9),
                    onDraw: () {},
                    onCheckMate: (loser) {},
                    onMove: (move) {},
                    onCheck: (color) {},
                    chessBoardController: controller,
                    boardType: BoardType.darkBrown,
                    enableUserMoves: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Image.asset(
                        (createWhite
                            ? "assets/images/magnus_carlsen.jpeg"
                            : "assets/images/garry_kasparov.jpg"),
                        width: 70,
                        height: 70,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text((createWhite ? player1 : player2),
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Watch Chess Room"),
        centerTitle: true,
      ),
      body: Container(
        child: Container(
          child: (screen == 0 ? formRoomID() : chessBoard()),
        ),
      ),
    );
  }
}
