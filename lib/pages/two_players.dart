import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:custom_timer/custom_timer.dart';
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
    child: Text("Rematch"),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/two_players');
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
  bool isTimeOut = false;
  String _fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

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

  @override
  void initState() {
    super.initState();
    turn = 0;
    _fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
    isTimeOut = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("2 Players"),
        ),
        body: Container(
          child: Column(
            children: [
              CustomTimer(
                controller: blackController,
                from: Duration(seconds: 10),
                to: Duration(seconds: 0),
                builder: (CustomTimerRemainingTime remaining) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 5.0, top: 5.0),
                    child: Row(
                      children: [
                        BlackKing(
                          size: MediaQuery.of(context).size.width * 0.1,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text("Black",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10.0, bottom: 10.0),
                          child: Text(
                            "${remaining.minutes}:${remaining.seconds}",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        )
                      ],
                    ),
                  );
                },
                onFinish: () {
                  isTimeOut = true;
                  whiteController.pause();
                  blackController.pause();
                  showAlertDialog(
                      context, "Black has lost on time. White wins");
                },
              ),
              Expanded(
                child: Center(
                  child: ChessBoard(
                    size: MediaQuery.of(context).size.width * 0.9,
                    onDraw: () {
                      whiteController.pause();
                      blackController.pause();
                      showAlertDialog(context, "Draw");
                    },
                    onCheckMate: (loser) {
                      whiteController.pause();
                      blackController.pause();
                      if (loser == PieceColor.Black) {
                        showAlertDialog(context, "Checkmate. White wins");
                      } else {
                        showAlertDialog(context, "Checkmate. Black wins");
                      }
                    },
                    onMove: (move) {
                      if (isTimeOut == false) {
                        if (turn == 0) {
                          whiteMove();
                        } else {
                          blackMove();
                        }
                        turn = 1 - turn;
                      }
                    },
                    onCheck: (color) {},
                    chessBoardController: controller,
                    enableUserMoves: true,
                  ),
                ),
              ),
              CustomTimer(
                controller: whiteController,
                from: Duration(seconds: 10),
                to: Duration(hours: 0),
                builder: (CustomTimerRemainingTime remaining) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 5.0, top: 5.0),
                    child: Row(
                      children: [
                        WhiteKing(
                          size: MediaQuery.of(context).size.width * 0.1,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text("White",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10.0, bottom: 10.0),
                          child: Text(
                            "${remaining.minutes}:${remaining.seconds}",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        )
                      ],
                    ),
                  );
                },
                onBuildAction: CustomTimerAction.auto_start,
                onFinish: () {
                  isTimeOut = true;
                  whiteController.pause();
                  blackController.pause();
                  showAlertDialog(
                      context, "White has lost on time. Black wins");
                },
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ));
  }
}
