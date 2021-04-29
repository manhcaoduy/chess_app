import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:chess_app/utils/utils.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class ComputerPlay extends StatefulWidget {
  final ChessBoardController controller = new ChessBoardController();
  String fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  bool isGameOver = false;
  String endgameResult = '';

  @override
  _ComputerPlayState createState() => _ComputerPlayState();
}

class _ComputerPlayState extends State<ComputerPlay> {
  ChessBoardController controller = new ChessBoardController();
  String _fen = '';
  bool isGameOver = false;
  String endgameResult = '';

  void dialog(BuildContext context, String messenge) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(messenge, style: TextStyle(fontSize: 20)),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    _fen = widget.fen;
    isGameOver = widget.isGameOver;
    endgameResult = widget.endgameResult;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      controller.game.load(_fen);
      controller.refreshBoard();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text((isGameOver ? endgameResult : "Play with Computer")),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/computer_logo.jpeg',
                    width: 100,
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Alpha Zero",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: ChessBoard(
                  size: MediaQuery.of(context).size.width,
                  onDraw: () {
                    if (isGameOver) return;
                    dialog(context, "Draw");
                    setState(() {
                      isGameOver = true;
                      endgameResult = "Draw.";
                    });
                  },
                  onCheckMate: (loser) {
                    if (isGameOver) return;
                    dialog(
                        context,
                        (loser == PieceColor.Black
                            ? "Checkmate. White wins"
                            : "Checkmate. Black wins"));
                    setState(() {
                      isGameOver = true;
                      endgameResult =
                          (loser == PieceColor.Black ? "Win" : "Lose");
                    });
                  },
                  onMove: (move) {
                    _fen = controller.game.fen;
                    final nextMove = getRandomMove(_fen);
                    if (nextMove != null) {
                      _fen = makeMove(_fen, nextMove);
                      Future.delayed(Duration(milliseconds: 300)).then((_) {
                        controller.game.load(_fen);
                        controller.refreshBoard();
                      });
                    }
                  },
                  onCheck: (color) {},
                  chessBoardController: controller,
                  enableUserMoves: (isGameOver ? false : true),
                  boardType: BoardType.darkBrown,
                ),
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
                                    Navigator.of(context).pop();
                                    setState(() {
                                      isGameOver = true;
                                      endgameResult = "Lose";
                                    });
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
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (isGameOver) return;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('New game'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        'Do you really want to restart a new game.'),
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
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _fen =
                                          'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
                                      isGameOver = false;
                                      endgameResult = "";
                                    });
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
                          Icons.autorenew,
                          color: Colors.white,
                          size: 40.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
