import 'package:audioplayers/audio_cache.dart';
import 'package:chess_app/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:custom_timer/custom_timer.dart';

class TwoPlayers extends StatefulWidget {
  @override
  _TwoPlayersState createState() => _TwoPlayersState();
}

class _TwoPlayersState extends State<TwoPlayers> {
  // Constants
  final ChessBoardController controller = new ChessBoardController();
  final CustomTimerController whiteController = new CustomTimerController();
  final CustomTimerController blackController = new CustomTimerController();
  GlobalKey<_PauseButtonState> pauseGlobalKey = GlobalKey();
  GlobalKey<_CircleStatusState> circle1GlobalKey = GlobalKey();
  GlobalKey<_CircleStatusState> circle2GlobalKey = GlobalKey();
  final player = AudioCache(prefix: 'assets/sound/');
  int turn = 0;
  bool isGameOver = false;
  String endgameMessenge = '';
  String _fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  bool isPause = true;

  // White Move callback
  void whiteMove() {
    circle1GlobalKey.currentState.changeTurn(1);
    circle2GlobalKey.currentState.changeTurn(0);
    whiteController.pause();
    blackController.start();
  }

  // Black Move callback
  void blackMove() {
    circle1GlobalKey.currentState.changeTurn(0);
    circle2GlobalKey.currentState.changeTurn(1);
    whiteController.start();
    blackController.pause();
  }

  @override
  void initState() {
    super.initState();
    turn = 0;
    _fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
    isGameOver = false;
    endgameMessenge = '';
    isPause = true;
    player.loadAll([
      'check_sound.mp3',
      'gameover_sound.mp3',
      'move_sound.mp3',
      'start_sound.mp3',
    ]);
  }

  // Back button Pressed function
  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                  "Do you really want to quit. The game will be canceled."),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Yes"),
                )
              ],
            ));
  }

  // timer finished function
  void _onTimerFinished(String piece) {
    if (isGameOver) return;
    circle1GlobalKey.currentState.changeTurn(1);
    circle2GlobalKey.currentState.changeTurn(1);
    pauseGlobalKey.currentState.changeSymbol(0);
    player.play("gameover_sound.mp3", volume: 20.0);
    whiteController.pause();
    blackController.pause();
    dialog(
      context,
      (piece == 'white'
          ? "White has lost on time. Black wins"
          : "Black has lost on time. White wins"),
      (piece == 'white' ? 1 : 0),
    );
    setState(() {
      isGameOver = true;
      endgameMessenge =
          (piece == 'white' ? "White lost on time" : "Black lost on time");
    });
  }

  // restart game function
  void _onRestartGame() {
    circle1GlobalKey.currentState.changeTurn(1);
    circle2GlobalKey.currentState.changeTurn(1);
    pauseGlobalKey.currentState.changeSymbol(0);
    player.play("start_sound.mp3", volume: 20.0);
    Navigator.of(context).pop();
    whiteController.reset();
    blackController.reset();
    setState(() {
      turn = 0;
      _fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
      isGameOver = false;
      endgameMessenge = '';
      isPause = true;
    });
  }

  // pause button pressed funtion
  void _onPauseButton() {
    if (isGameOver) return;
    if (turn == 0) {
      if (isPause) {
        whiteController.start();
        circle1GlobalKey.currentState.changeTurn(0);
      } else {
        whiteController.pause();
        circle1GlobalKey.currentState.changeTurn(1);
      }
    } else {
      if (isPause) {
        blackController.start();
        circle2GlobalKey.currentState.changeTurn(0);
      } else {
        blackController.pause();
        circle2GlobalKey.currentState.changeTurn(0);
      }
    }
    pauseGlobalKey.currentState.changeSymbol((isPause ? 1 : 0));
    isPause = !isPause;
  }

  // onDraw function
  void _onDraw() {
    if (isGameOver) return;
    circle1GlobalKey.currentState.changeTurn(1);
    circle2GlobalKey.currentState.changeTurn(1);
    pauseGlobalKey.currentState.changeSymbol(0);
    player.play("gameover_sound.mp3", volume: 20.0);
    whiteController.pause();
    blackController.pause();
    dialog(context, "Draw", 2);
    setState(() {
      isGameOver = true;
      endgameMessenge = "Draw";
    });
  }

  // onCheckmate function
  Null _onCheckmate(PieceColor loser) {
    if (isGameOver) return;
    circle1GlobalKey.currentState.changeTurn(1);
    circle2GlobalKey.currentState.changeTurn(1);
    pauseGlobalKey.currentState.changeSymbol(0);
    player.play("gameover_sound.mp3", volume: 20.0);
    whiteController.pause();
    blackController.pause();

    dialog(
      context,
      ((loser == PieceColor.Black)
          ? "Checkmate. White wins"
          : "Checkmate. Black wins"),
      ((loser == PieceColor.Black) ? 0 : 1),
    );
    setState(() {
      isGameOver = true;
      endgameMessenge = ((loser == PieceColor.Black)
          ? "Checkmate. White wins"
          : "Checkmate. Black wins");
    });
  }

  //onCheck function
  Null _onCheck(PieceColor color) {
    player.disableLog();
    player.play("check_sound.mp3", volume: 20.0);
  }

  // onMove function
  Null _onMove(String move) {
    if (isGameOver) return;

    if (isPause) {
      controller.game.load(_fen);
      controller.refreshBoard();
      return;
    }

    player.play("move_sound.mp3", volume: 5);

    if (turn == 0) {
      whiteMove();
    } else {
      blackMove();
    }
    turn = 1 - turn;
    _fen = controller.game.fen;
  }

  @override
  Widget build(BuildContext context) {
    player.play("start_sound.mp3", volume: 20.0);
    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      controller.game.load(_fen);
      controller.refreshBoard();
    });

    return WillPopScope(
      onWillPop: (isGameOver
          ? () {
              Navigator.pop(context, false);
              return new Future(() => false);
            }
          : _onBackPressed),
      child: Scaffold(
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
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 5.0,
                                  top: 5.0),
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
                                  CircleStatus(key: circle2GlobalKey),
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
                            _onTimerFinished("black");
                          },
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
                                CircleStatus(key: circle1GlobalKey),
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
                        onFinish: () {
                          _onTimerFinished('white');
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
                      PauseButton(
                        key: pauseGlobalKey,
                        onPause: _onPauseButton,
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
                                        _onRestartGame();
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
          )),
    );
  }
}

class PauseButton extends StatefulWidget {
  final Function() onPause;
  PauseButton({@required Key key, @required this.onPause}) : super(key: key);
  @override
  _PauseButtonState createState() => _PauseButtonState();
}

class _PauseButtonState extends State<PauseButton> {
  int symbol; // = 0 pause, = 1 resume

  @override
  void initState() {
    super.initState();
    symbol = 0;
  }

  void changeSymbol(int newSymbol) {
    setState(() {
      symbol = newSymbol;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onPause,
      icon: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Icon(
            (symbol == 0 ? Icons.play_arrow : Icons.pause_outlined),
            color: Colors.white,
            size: 40.0,
          ),
        ),
      ),
    );
  }
}

class CircleStatus extends StatefulWidget {
  CircleStatus({@required Key key}) : super(key: key);
  @override
  _CircleStatusState createState() => _CircleStatusState();
}

class _CircleStatusState extends State<CircleStatus> {
  int turn; // = 0 pause, = 1 resume

  @override
  void initState() {
    super.initState();
    turn = 1;
  }

  void changeTurn(int newTurn) {
    setState(() {
      turn = newTurn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 20,
        width: 20,
        decoration: (turn == 0
            ? BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              )
            : BoxDecoration()),
      ),
    );
  }
}
