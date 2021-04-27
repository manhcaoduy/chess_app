import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chess_app/data/piece_data.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class PieceDetailPage extends StatefulWidget {
  final int position;

  PieceDetailPage({@required this.position});

  @override
  _PieceDetailPageState createState() => _PieceDetailPageState();
}

class _PieceDetailPageState extends State<PieceDetailPage> {
  _PieceDetailPageState();

  // Constants
  ChessBoardController controller = new ChessBoardController();

  // Stream Events makes automatical move after every one second by sending non-sense data every one second
  Stream<int> streamEvent(fens, moves, clear) async* {
    int len = moves.length;
    int id = len;
    while (true) {
      if (id == len) {
        if (clear == true) {
          controller.clearBoard();
          for (var fen in fens) {
            controller.putPiece(fen.type, fen.cell, fen.color);
          }
        } else {
          controller.resetBoard();
        }
      } else {
        var move = moves[id];
        controller.makeMove(move.from, move.to);
      }
      yield id;
      id = (id + 1) % (len + 1);
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    var fens = pieces[widget.position].future['fen'];
    var moves = pieces[widget.position].future['move'];
    var clear = pieces[widget.position].clear;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          _buildTitle(),
          _buildContent(),
          _buildChessBoard(MediaQuery.of(context).size),
          StreamBuilder(
            stream: streamEvent(fens, moves, clear),
            builder: (context, snapshot) {
              return Container();
            },
          )
        ],
      )),
    );
  }

  // Title Widget
  Widget _buildTitle() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Hero(
              tag: "Piece${widget.position}",
              child: pieces[widget.position].pieceWidget),
        ),
        Text(
          pieces[widget.position].name,
          style: TextStyle(
            fontSize: 24.0,
          ),
        )
      ],
    );
  }

  // Content Widget
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 32.0),
      child: Text(
        pieces[widget.position].information,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  // Chessboard Widget
  Widget _buildChessBoard(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ChessBoard(
        size: size.width,
        onDraw: () {},
        onCheckMate: (winColor) {},
        onMove: (move) {},
        onCheck: (color) {},
        chessBoardController: controller,
        enableUserMoves: false,
      ),
    );
  }
}
