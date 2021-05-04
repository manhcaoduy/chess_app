import 'package:chess_app/redux/actions.dart';
import 'package:chess_app/redux/data.dart';
import 'package:chess_app/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:chess_app/utils/utils.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:audioplayers/audio_cache.dart';

// Computer data format taken from the redux store
class _ComputerData {
  final String fen;
  final bool isGameOver;
  final Function(String, String) onUpdateEndgameMessenge;
  final Function() onRestart;
  final Function(String) onUpdateNewFen;

  _ComputerData({
    this.fen,
    this.isGameOver,
    this.onUpdateEndgameMessenge,
    this.onRestart,
    this.onUpdateNewFen,
  });

  factory _ComputerData.create(Store<AppState> store) {
    _onUpdateEndgameMessenge(String fen, String messenge) {
      store.dispatch(ComputerEndgameAction(
        endgameMessenge: messenge,
        fen: fen,
      ));
    }

    _onRestart() {
      store.dispatch(ComputerRestartAction());
    }

    _onUpdateNewFen(String newFen) {
      store.dispatch(ComputerUpdateFen(newFen));
    }

    return _ComputerData(
      fen: store.state.computerPlay.fen,
      isGameOver: store.state.computerPlay.isGameOver,
      onUpdateEndgameMessenge: _onUpdateEndgameMessenge,
      onRestart: _onRestart,
      onUpdateNewFen: _onUpdateNewFen,
    );
  }
}

class ComputerPlay extends StatefulWidget {
  @override
  _ComputerPlayState createState() => _ComputerPlayState();
}

class _ComputerPlayState extends State<ComputerPlay> {
  // constants
  ChessBoardController controller = new ChessBoardController();
  String _fen;
  final player = AudioCache(prefix: 'assets/sound/');

  // initialize variables
  @override
  void initState() {
    super.initState();
    player.loadAll([
      'check_sound.mp3',
      'gameover_sound.mp3',
      'move_sound.mp3',
      'start_sound.mp3',
    ]);
    player.play('start_sound.mp3', volume: 20.0);
  }

  // onDraw function
  void _onDrawCallback(_ComputerData data) {
    if (data.isGameOver) return;

    player.play("gameover_sound.mp3", volume: 20.0);
    dialog(context, "Draw");
    data.onUpdateEndgameMessenge(_fen, "Draw!!!");
  }

  // onCheckmate function
  void _onCheckmateCallback(PieceColor loser, _ComputerData data) {
    if (data.isGameOver) return;

    player.play("gameover_sound.mp3", volume: 20.0);
    dialog(
      context,
      (loser == PieceColor.Black
          ? "Checkmate. White wins"
          : "Checkmate. Black wins"),
    );
    data.onUpdateEndgameMessenge(
      _fen,
      (loser == PieceColor.Black ? "Win" : "Lose"),
    );
  }

  // onMove function
  Null _onMoveCallback(String move) {
    player.play("move_sound.mp3", volume: 5.0);
    _fen = controller.game.fen;
    final nextMove = getRandomMove(_fen);
    if (nextMove != null) {
      _fen = makeMove(_fen, nextMove);
      Future.delayed(Duration(milliseconds: 300)).then((_) {
        controller.game.load(_fen);
        controller.refreshBoard();
      });
    }
  }

  // onCheck function
  Null _onCheck(PieceColor color) {
    player.disableLog();
    player.play("check_sound.mp3", volume: 20.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StoreConnector<AppState, ComputerPlayState>(
          converter: (store) => store.state.computerPlay,
          builder: (context, ComputerPlayState state) => Text(
            (state.isGameOver ? state.endgameResult : "Play with Computer"),
          ),
        ),
        centerTitle: true,
        leading: StoreConnector<AppState, _ComputerData>(
          converter: (store) => _ComputerData.create(store),
          builder: (context, _ComputerData data) => IconButton(
            icon: new Icon(
              Icons.arrow_back,
              size: 30,
            ),
            onPressed: () {
              data.onUpdateNewFen(_fen);
              Navigator.of(context).pop();
            },
          ),
        ),
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
                child: StoreConnector<AppState, _ComputerData>(
                    converter: (store) => _ComputerData.create(store),
                    builder: (context, _ComputerData data) {
                      // update board everytime the widget is rebuilt
                      Future.delayed(const Duration(microseconds: 300))
                          .then((value) {
                        controller.game.load(data.fen);
                        controller.refreshBoard();
                      });
                      _fen = data.fen;

                      return ChessBoard(
                        size: MediaQuery.of(context).size.width,
                        onDraw: () {
                          _onDrawCallback(data);
                        },
                        onCheckMate: (loser) {
                          _onCheckmateCallback(loser, data);
                        },
                        onMove: _onMoveCallback,
                        onCheck: _onCheck,
                        chessBoardController: controller,
                        enableUserMoves: (data.isGameOver ? false : true),
                        boardType: BoardType.darkBrown,
                      );
                    }),
              ),
            ),
            StoreConnector<AppState, _ComputerData>(
              builder: (context, _ComputerData data) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (data.isGameOver) return;
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
                                      // resign
                                      player.play("gameover_sound.mp3",
                                          volume: 20.0);
                                      Navigator.of(context).pop();
                                      data.onUpdateEndgameMessenge(
                                        _fen,
                                        "Lose",
                                      );
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
                                      // restart
                                      player.play("start_sound.mp3",
                                          volume: 20.0);
                                      Navigator.of(context).pop();
                                      data.onRestart();
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
              ),
              converter: (store) => _ComputerData.create(store),
            ),
          ],
        ),
      ),
    );
  }
}
