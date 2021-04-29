import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class TwoPlayers extends StatefulWidget {
  @override
  _TwoPlayersState createState() => _TwoPlayersState();
}

class _TwoPlayersState extends State<TwoPlayers> {
  // Constants
  final ChessBoardController controller = new ChessBoardController();
  final CustomTimerController whiteController = new CustomTimerController();
  final CustomTimerController blackController = new CustomTimerController();
  int turn = 0;
  bool isGameOver = false;
  String endgameMessenge = '';
  String _fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  bool isPause = true;

  // White Move callback
  void whiteMove() {
    whiteController.pause();
    blackController.start();
  }

  // Black Move callback
  void blackMove() {
    whiteController.start();
    blackController.pause();
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

  @override
  void initState() {
    super.initState();
    turn = 0;
    _fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
    isGameOver = false;
    endgameMessenge = '';
    isPause = false;
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      controller.game.load(_fen);
      controller.refreshBoard();
    });

    return Scaffold(
        appBar: AppBar(
          title: Text(isGameOver ? endgameMessenge : "2 Players"),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RotationTransition(
                      turns: new AlwaysStoppedAnimation(180 / 360),
                      child: CustomTimer(
                        controller: blackController,
                        from: Duration(minutes: 10),
                        to: Duration(seconds: 0),
                        builder: (CustomTimerRemainingTime remaining) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 5.0, top: 5.0),
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
                                    child: Text("Garry Kasparov",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: Text(
                                    "${remaining.minutes}:${remaining.seconds}",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                ),
                              ],
                            ),
                          );
                        },
                        onFinish: () {
                          if (isGameOver) return;
                          whiteController.pause();
                          blackController.pause();
                          dialog(context, "Black has lost on time. White wins");
                          setState(() {
                            isGameOver = true;
                            endgameMessenge = "Black lost on time";
                          });
                        },
                      ),
                    ),
                    Center(
                      child: ChessBoard(
                        size: (MediaQuery.of(context).size.height > 700
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.width * 0.9),
                        onDraw: () {
                          if (isGameOver) return;
                          whiteController.pause();
                          blackController.pause();
                          dialog(context, "Draw");
                          setState(() {
                            isGameOver = true;
                            endgameMessenge = "Draw";
                          });
                        },
                        onCheckMate: (loser) {
                          if (isGameOver) return;
                          whiteController.pause();
                          blackController.pause();

                          dialog(
                              context,
                              ((loser == PieceColor.Black)
                                  ? "Checkmate. White wins"
                                  : "Checkmate. Black wins"));
                          setState(() {
                            isGameOver = true;
                            endgameMessenge = ((loser == PieceColor.Black)
                                ? "Checkmate. White wins"
                                : "Checkmate. Black wins");
                          });
                        },
                        onMove: (move) {
                          if (isGameOver) return;
                          if (turn == 0) {
                            whiteMove();
                          } else {
                            blackMove();
                          }
                          turn = 1 - turn;
                          _fen = controller.game.fen;
                        },
                        onCheck: (color) {},
                        chessBoardController: controller,
                        enableUserMoves: (isGameOver ? false : true),
                        boardType: BoardType.darkBrown,
                      ),
                    ),
                    CustomTimer(
                      controller: whiteController,
                      from: Duration(minutes: 10),
                      to: Duration(hours: 0),
                      builder: (CustomTimerRemainingTime remaining) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 5.0, top: 5.0),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/magnus_carlsen.jpeg",
                                width: 70,
                                height: 70,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Magnus Carlsen",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: Text(
                                  "${remaining.minutes}:${remaining.seconds}",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                              )
                            ],
                          ),
                        );
                      },
                      onBuildAction: CustomTimerAction.auto_start,
                      onFinish: () {
                        if (isGameOver) return;
                        whiteController.pause();
                        blackController.pause();
                        dialog(context, "White has lost on time. Black wins");
                        setState(() {
                          isGameOver = true;
                          endgameMessenge = "White lost on time";
                        });
                      },
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
                      },
                      icon: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Icon(
                            // Icons.play_arrow,
                            Icons.pause_outlined,
                            color: Colors.white,
                            size: 40.0,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
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
                                      whiteController.reset();
                                      blackController.reset();
                                      whiteController.start();
                                      setState(() {
                                        turn = 0;
                                        _fen =
                                            'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
                                        isGameOver = false;
                                        endgameMessenge = '';
                                        isPause = false;
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
        ));
  }
}
