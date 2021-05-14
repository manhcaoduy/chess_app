import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:chess_app/utils/dialog_state.dart';
import 'package:chess_app/widget/circle_status.dart';
import 'package:chess_app/widget/dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:chess_app/utils/validator.dart';

class OnlineCreateScreen extends StatefulWidget {
  @override
  _OnlineCreateScreenState createState() => _OnlineCreateScreenState();
}

class _OnlineCreateScreenState extends State<OnlineCreateScreen>
    with Validator {
  // immutable variables
  final TextEditingController _nameController = TextEditingController();
  final ChessBoardController controller = new ChessBoardController();
  GlobalKey<CircleStatusState> circle1GlobalKey = GlobalKey();
  GlobalKey<CircleStatusState> circle2GlobalKey = GlobalKey();
  final databaseReference = FirebaseDatabase.instance.reference();
  final String alphanum = '0123456789';
  final _formKey = GlobalKey<FormState>();
  final player = AudioCache(prefix: 'assets/sound/');

  // mutable variables
  String fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  final double minValue = 8.0;
  String roomId = "";
  bool isWhite = true;
  String turn = 'white';
  bool isGameOver = false;
  String player1 = "";
  String player2 = "";
  int screen = 0;
  String dropdownValue = "White";
  bool isStart = false;
  String endgameMessenge = "";
  bool quit = false;

  // Generate room ID
  String key(int length) {
    var text = '';
    var random = new Random();
    for (var i = 0; i < length; i++)
      text += this.alphanum[random.nextInt(this.alphanum.length)];
    return text;
  }
  /* ----------------------------------------------------------------------------------------------------------------------------------------- */

  @override
  void initState() {
    super.initState();
    fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
    isGameOver = false;
    isWhite = true;
    screen = 0;
    turn = "white";
    dropdownValue = "White";
    player1 = "";
    player2 = "";
    isStart = false;
    endgameMessenge = "";
    quit = false;
    player.loadAll([
      'check_sound.mp3',
      'gameover_sound.mp3',
      'move_sound.mp3',
      'start_sound.mp3',
    ]);
  }
  /* ----------------------------------------------------------------------------------------------------------------------------------------- */

  // error text form style
  final TextStyle _errorStyle = TextStyle(
    color: Colors.red,
    fontSize: 16.6,
  );

  // on form submit function
  void _onFormSubmit() {
    if (_formKey.currentState.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Processing Room ID')));
      var name = _nameController.text;
      roomId = key(6);
      var createWhite = (dropdownValue == 'White');
      databaseReference.child("$roomId").set({
        "fen": fen,
        "turn": "white",
        "start": false,
        "create_white": createWhite,
        "name_1": name,
        "name_2": '',
        "gameover": false,
        "endgame_status": '',
      });
      FirebaseDatabase.instance
          .reference()
          .child("$roomId")
          .onValue
          .listen((event) {
        fen = event.snapshot.value['fen'];
        turn = event.snapshot.value['turn'];
        var start = event.snapshot.value['start'];
        var isGameoverDb = event.snapshot.value['gameover'];
        var endgameMessengeDb = event.snapshot.value['endgame_status'];

        if (screen == 2) {
          if (isGameoverDb && !quit) {
            circle1GlobalKey.currentState.changeTurn(0);
            circle2GlobalKey.currentState.changeTurn(0);
          } else {
            if ((turn == 'white' && isWhite) || (turn == 'black' && !isWhite)) {
              circle1GlobalKey.currentState.changeTurn(1);
              circle2GlobalKey.currentState.changeTurn(0);
            } else {
              circle1GlobalKey.currentState.changeTurn(0);
              circle2GlobalKey.currentState.changeTurn(1);
            }
          }
        }

        Future.delayed(const Duration(milliseconds: 200)).then((value) {
          if (!quit &&
              !isGameoverDb &&
              fen !=
                  "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") {
            player.play("move_sound.mp3", volume: 5);
          }
          controller.game.load(fen);
          controller.refreshBoard();
        });
        if (start && !isStart) {
          player.play("start_sound.mp3", volume: 20.0);
          Future.delayed(const Duration(milliseconds: 200)).then((value) {
            if ((turn == 'white' && isWhite) || (turn == 'black' && !isWhite)) {
              circle1GlobalKey.currentState.changeTurn(1);
              circle2GlobalKey.currentState.changeTurn(0);
            } else {
              circle1GlobalKey.currentState.changeTurn(0);
              circle2GlobalKey.currentState.changeTurn(1);
            }
          });
          setState(() {
            isStart = true;
            player2 = event.snapshot.value['name_2'];
            screen = 2;
          });
        }
        if (isGameoverDb && !isGameOver && !quit) {
          player.play("gameover_sound.mp3", volume: 20.0);
          dialog(context, endgameMessenge, dialogState(endgameMessenge));
          setState(() {
            isGameOver = true;
            endgameMessenge = endgameMessengeDb;
          });
        }
      });
      setState(() {
        player1 = name;
        isWhite = createWhite;
        screen = 1;
      });
    }
  }

  // form widget
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
                    height: minValue * 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: minValue, vertical: minValue),
                      child: TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                        maxLines: 2,
                        validator: nameValidator,
                        decoration: InputDecoration(
                            errorStyle: _errorStyle,
                            border: InputBorder.none,
                            labelText: 'Name',
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
                    height: minValue * 4,
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['White', 'Black']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: (value == "White"
                            ? WhiteKing(
                                size: 50,
                              )
                            : BlackKing(
                                size: 50,
                              )),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: minValue * 4,
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
                        _onFormSubmit();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: minValue * 2.4),
                        elevation: 0.0,
                        primary: Colors.transparent,
                      ),
                      child: Text('Create'),
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

  /* ----------------------------------------------------------------------------------------------------------------------------------------- */

  void _onDraw() {
    if (isGameOver) return;

    player.play("gameover_sound.mp3", volume: 20.0);
    dialog(context, "Draw", 2);
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        controller.game.load(fen);
        controller.refreshBoard();
      });
      if ((isWhite && turn == 'white') || (!isWhite && turn == 'black')) {
        databaseReference.child("$roomId").update({
          "gameover": true,
          "endgame_status": 'Draw !!!!',
        });
      }
      setState(() {
        isGameOver = true;
        endgameMessenge = "Draw !!!!";
      });
    });
  }

  Null _onCheckmate(PieceColor loser) {
    if (isGameOver) return;

    player.play("gameover_sound.mp3", volume: 20.0);
    if (loser == PieceColor.Black) {
      dialog(context, "Checkmate. White wins", 0);
    } else {
      dialog(context, "Checkmate. Black wins", 1);
    }
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      if ((isWhite && turn == 'white') || (!isWhite && turn == 'black')) {
        databaseReference.child("$roomId").update({
          "gameover": true,
          "endgame_status": (loser == PieceColor.Black
              ? "Checkmate. White wins."
              : "Checkmate. Black wins"),
        });
      }
      setState(() {
        endgameMessenge = (loser == PieceColor.Black
            ? "Checkmate. White wins."
            : "Checkmate. Black wins");
        isGameOver = true;
      });
    });
  }

  Null _onMove(String move) {
    if ((turn == "white" && !isWhite) || (turn == "black" && isWhite)) {
      controller.game.load(fen);
      controller.refreshBoard();
      return;
    }
    fen = controller.game.fen;
    turn = (isWhite) ? "black" : "white";
    databaseReference.child("$roomId").update({
      "fen": fen,
      "turn": (isWhite) ? "black" : "white",
    });
  }

  Null _onCheck(PieceColor color) {
    player.disableLog();
    player.play("check_sound.mp3", volume: 20.0);
  }

  void _onResign() {
    player.play("gameover_sound.mp3", volume: 20.0);
    Navigator.of(context).pop();
    databaseReference.child("$roomId").update({
      "gameover": true,
      "endgame_status": (isWhite
          ? "White resigns. Black wins."
          : "Black resigns. White wins"),
    });
    setState(() {
      isGameOver = true;
      endgameMessenge = (isWhite
          ? "White resigns. Black wins."
          : "Black resigns. White wins");
    });
  }

  Widget chessboard() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
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
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/garry_kasparov.jpg",
                      width: 70,
                      height: 70,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(player2,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    CircleStatus(key: circle2GlobalKey),
                  ],
                ),
              ),
              Center(
                child: ChessBoard(
                  size: (MediaQuery.of(context).size.height > 700
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width * 0.85),
                  onDraw: _onDraw,
                  onCheckMate: _onCheckmate,
                  onMove: _onMove,
                  onCheck: _onCheck,
                  chessBoardController: controller,
                  enableUserMoves: (isGameOver ? false : true),
                  whiteSideTowardsUser: isWhite,
                  boardType: BoardType.darkBrown,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/magnus_carlsen.jpeg",
                      width: 70,
                      height: 70,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(player1,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    CircleStatus(key: circle1GlobalKey),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  if (isGameOver) return;
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Resign'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Do you really want to resign.'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Yes'),
                              onPressed: () {
                                _onResign();
                              },
                            ),
                          ],
                        );
                      });
                },
                icon: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Icon(
                      Icons.emoji_flags,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  /* ----------------------------------------------------------------------------------------------------------------------------------------- */

  // waiting for opponent
  Widget waiting() {
    return Container(
      color: Colors.black38,
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text("Room $roomId",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 30,
            ),
            Text("Waiting for the opponent...........",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            Expanded(
                child: Center(
              child: CircularProgressIndicator(),
            )),
          ],
        ),
      ),
    );
  }

  /* ----------------------------------------------------------------------------------------------------------------------------------------- */

  void _onQuit() {
    quit = true;
    databaseReference.child("$roomId").update({
      "gameover": true,
      "endgame_status": (isStart
          ? (isWhite ? "White quits. Black wins!" : "Black quits. White wins")
          : "No opponent."),
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  // on back pressed function
  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(isStart
                  ? "Do you really want to quit. You will be counter as loser."
                  : "Do you really want to quit. The game will be canceled."),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    _onQuit();
                  },
                  child: Text("Yes"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text("Online Play"),
            ),
            body: Container(
              child: (screen == 0
                  ? formRoomID()
                  : (screen == 1 ? waiting() : chessboard())),
            )),
        onWillPop: (isGameOver || screen == 0
            ? () {
                Navigator.pop(context, false);
                return new Future(() => false);
              }
            : _onBackPressed));
  }
}
