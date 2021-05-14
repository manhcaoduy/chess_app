import 'package:audioplayers/audio_cache.dart';
import 'package:chess_app/utils/dialog_state.dart';
import 'package:chess_app/widget/circle_status.dart';
import 'package:chess_app/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chess_app/utils/validator.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:firebase_database/firebase_database.dart';

class OnlineJoinScreen extends StatefulWidget {
  @override
  _OnlineJoinScreenState createState() => _OnlineJoinScreenState();
}

class _OnlineJoinScreenState extends State<OnlineJoinScreen> with Validator {
  // constants
  final databaseReference = FirebaseDatabase.instance.reference();
  final TextEditingController _roomIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final ChessBoardController controller = new ChessBoardController();
  GlobalKey<CircleStatusState> circle1GlobalKey = GlobalKey();
  GlobalKey<CircleStatusState> circle2GlobalKey = GlobalKey();
  final player = AudioCache(prefix: 'assets/sound/');
  final double minValue = 8.0;
  final _formKey = GlobalKey<FormState>();
  String roomId = "";
  int screen = 0;
  String turn = "";
  String fen = "";
  String player1 = "";
  String player2 = "";
  bool isGameOver = false;
  bool isWhite = false;
  String endgameMessenge = "";
  bool quit = false;

  @override
  void initState() {
    super.initState();
    screen = 0;
    turn = "white";
    fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
    isGameOver = false;
    endgameMessenge = "";
    quit = false;
    player.loadAll([
      'check_sound.mp3',
      'gameover_sound.mp3',
      'move_sound.mp3',
      'start_sound.mp3',
    ]);
  }

  // -------------------------------------------- form ----------------------------------------------
  // form text error style
  final TextStyle _errorStyle = TextStyle(
    color: Colors.red,
    fontSize: 16.6,
  );

  void _onForm() {
    if (_formKey.currentState.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Processing Room ID')));
      var inputRoomId = _roomIdController.text;
      var name = _nameController.text;
      databaseReference.child("$inputRoomId").once().then((snapshot) {
        if (snapshot.value == null ||
            (snapshot.value["start"] == true ||
                snapshot.value["gameover"] == true)) {
          dialog(context, "Room ID $inputRoomId has not been created yet", 3);
        } else if (snapshot.value["start"] == true) {
          dialog(
              context,
              "Room ID $inputRoomId has already started. You cannot join as player. But you can spectate it.",
              3);
        } else {
          roomId = inputRoomId;
          databaseReference.child("$roomId").update({
            "start": true,
            "name_2": name,
          });
          Future.delayed(const Duration(microseconds: 200)).then((value) {
            controller.game.load(snapshot.value["fen"]);
            controller.refreshBoard();
          });
          FirebaseDatabase.instance
              .reference()
              .child("$roomId")
              .onValue
              .listen((event) {
            fen = event.snapshot.value['fen'];
            turn = event.snapshot.value['turn'];
            var isGameoverDb = event.snapshot.value['gameover'];
            var endgameMessengeDb = event.snapshot.value['endgame_status'];

            if (screen == 1) {
              if (isGameoverDb && !quit) {
                circle1GlobalKey.currentState.changeTurn(0);
                circle2GlobalKey.currentState.changeTurn(0);
              } else {
                if ((turn == 'white' && isWhite) ||
                    (turn == 'black' && !isWhite)) {
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
            if (isGameoverDb && !isGameOver && !quit) {
              player.play("gameover_sound.mp3", volume: 20.0);
              dialog(
                  context, endgameMessengeDb, dialogState(endgameMessengeDb));
              setState(() {
                isGameOver = true;
                endgameMessenge = endgameMessengeDb;
              });
            }
          });
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
            player1 = snapshot.value["name_1"];
            player2 = name;
            isWhite = !snapshot.value["create_white"];
            screen = 1;
          });
        }
      });
    }
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
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: minValue * 4,
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
                        _onForm();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: minValue * 2.4),
                        elevation: 0.0,
                        primary: Colors.transparent,
                      ),
                      child: Text('Join'),
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
  // -------------------------------------------------------------------------------------------------------

  // -------------------------------------- Chessboard ---------------------------------------------------
  void _onDraw() {
    if (isGameOver) return;
    player.play("gameover_sound.mp3", volume: 20.0);
    dialog(context, "Draw", 2);
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      databaseReference.child("$roomId").update({
        "gameover": true,
        "endgame_status": 'Draw !!!!',
      });
      setState(() {
        endgameMessenge = "Draw !!!!";
        isGameOver = true;
      });
    });
  }

  Null _onCheckmate(PieceColor loser) {
    if (isGameOver) return;
    player.play("gameover_sound.mp3", volume: 20.0);
    dialog(
      context,
      (loser == PieceColor.Black
          ? "Checkmate. White wins"
          : "Checkmate. Black wins"),
      (loser == PieceColor.Black ? 0 : 1),
    );
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      databaseReference.child("$roomId").update({
        "gameover": true,
        "endgame_status": (loser == PieceColor.Black
            ? "Checkmate. White wins."
            : "Checkmate. Black wins"),
      });
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
    }
    fen = controller.game.fen;
    turn = (isWhite ? "black" : "white");
    databaseReference.child("$roomId").update({
      "fen": fen,
      "turn": (isWhite ? "black" : "white"),
    });
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

  Null _onCheck(PieceColor color) {
    player.disableLog();
    player.play("check_sound.mp3", volume: 20.0);
  }

  Widget chessBoard() {
    return Container(
      child: Column(
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
                      "assets/images/magnus_carlsen.jpeg",
                      width: 70,
                      height: 70,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(player1,
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
                    CircleStatus(key: circle1GlobalKey),
                  ],
                ),
              ),
            ],
          )),
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
                                onPressed: _onResign,
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
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                  "Do you really want to quit. You will be counter as loser."),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    quit = true;
                    databaseReference.child("$roomId").update({
                      "gameover": true,
                      "endgame_status": (isWhite
                          ? "White quits. Black wins!"
                          : "Black quits. White wins"),
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
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
            title: Text("Join Chess Room"),
          ),
          body: Container(
            child: Container(
              child: (screen == 0 ? formRoomID() : chessBoard()),
            ),
          ),
        ),
        onWillPop: (isGameOver || screen == 0
            ? () {
                Navigator.pop(context, false);
                return new Future(() => false);
              }
            : _onBackPressed));
  }
}
