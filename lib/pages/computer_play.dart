import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:chess_app/utils/utils.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:custom_timer/custom_timer.dart';

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

class ComputerPlay extends StatefulWidget {
  @override
  _ComputerPlayState createState() => _ComputerPlayState();
}

class _ComputerPlayState extends State<ComputerPlay> {
  String _fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  final ChessBoardController controller = new ChessBoardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Play with Computer"),
        ),
        body: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlackKing(
                    size: MediaQuery.of(context).size.width * 0.07,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Computer",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: ChessBoard(
                    size: MediaQuery.of(context).size.width - 200,
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
                      String _fen = controller.game.fen;

                      Future.delayed(Duration(milliseconds: 300)).then((_) {
                        final nextMove = getRandomMove(_fen);
                        if (nextMove != null) {
                          controller.game.load(makeMove(_fen, nextMove));
                          controller.refreshBoard();
                        }
                      });
                    },
                    onCheck: (color) {},
                    chessBoardController: controller,
                    enableUserMoves: true,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  WhiteKing(
                    size: MediaQuery.of(context).size.width * 0.07,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("You",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ));
  }
}
