import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

double pieceSize = 60.0;

final kingEvent = {
  "fen": [
    PiecePosition(PieceType.King, "e2", PieceColor.White),
    PiecePosition(PieceType.King, "e7", PieceColor.Black),
  ],
  "move": [
    PieceMove("e2", "e3"),
    PieceMove("e7", "e6"),
    PieceMove("e3", "f4"),
    PieceMove("e6", "d5"),
    PieceMove("f4", "g4"),
    PieceMove("d5", "c5"),
    PieceMove("g4", "h3"),
    PieceMove("c5", "b4"),
  ]
};

final rookEvent = {
  "fen": [
    PiecePosition(PieceType.King, "e2", PieceColor.White),
    PiecePosition(PieceType.King, "b7", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "d7", PieceColor.Black),
    PiecePosition(PieceType.Rook, "g7", PieceColor.White),
    PiecePosition(PieceType.Rook, "h1", PieceColor.White),
  ],
  "move": [
    PieceMove("g7", "d7"),
    PieceMove("b7", "a8"),
    PieceMove("h1", "h8"),
  ]
};

final bishopEvent = {
  "fen": [
    PiecePosition(PieceType.King, "d6", PieceColor.White),
    PiecePosition(PieceType.King, "d8", PieceColor.Black),
    PiecePosition(PieceType.Bishop, "c3", PieceColor.White),
    PiecePosition(PieceType.Bishop, "g6", PieceColor.White),
    PiecePosition(PieceType.Pawn, "f6", PieceColor.Black),
  ],
  "move": [
    PieceMove("c3", "f6"),
    PieceMove("d8", "c8"),
    PieceMove("d6", "c6"),
    PieceMove("c8", "b8"),
    PieceMove("c6", "b6"),
    PieceMove("b8", "a8"),
    PieceMove("g6", "f5"),
    PieceMove("a8", "b8"),
    PieceMove("f6", "e5"),
    PieceMove("b8", "a8"),
    PieceMove("f5", "e4"),
  ]
};

final knightEvent = {
  "fen": [
    PiecePosition(PieceType.King, "a1", PieceColor.White),
    PiecePosition(PieceType.King, "a8", PieceColor.Black),
    PiecePosition(PieceType.Knight, "c3", PieceColor.White),
    PiecePosition(PieceType.Pawn, "d3", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "e3", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "e4", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "e5", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "d5", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "c5", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "c4", PieceColor.Black),
  ],
  "move": [
    PieceMove("c3", "e4"),
    PieceMove("a8", "a7"),
    PieceMove("e4", "c5"),
    PieceMove("a7", "a8"),
    PieceMove("c5", "d3"),
    PieceMove("a8", "a7"),
    PieceMove("d3", "e5"),
    PieceMove("a7", "a8"),
    PieceMove("e5", "c4"),
    PieceMove("a8", "a7"),
    PieceMove("c4", "e3"),
    PieceMove("a7", "a8"),
    PieceMove("e3", "d5"),
    PieceMove("a8", "a7"),
    PieceMove("d5", "c3"),
    PieceMove("a7", "a8"),
  ]
};

final queenEvent = {
  "fen": [
    PiecePosition(PieceType.King, "d6", PieceColor.White),
    PiecePosition(PieceType.King, "e8", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "g7", PieceColor.Black),
    PiecePosition(PieceType.Queen, "a1", PieceColor.White),
  ],
  "move": [
    PieceMove("a1", "g7"),
    PieceMove("e8", "d8"),
    PieceMove("g7", "d7"),
  ]
};

final pawnEvent = {
  "fen": [
    PiecePosition(PieceType.King, "e1", PieceColor.White),
    PiecePosition(PieceType.King, "e8", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "a7", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "b7", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "c7", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "d7", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "e7", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "f7", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "g7", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "h7", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "a2", PieceColor.White),
    PiecePosition(PieceType.Pawn, "b2", PieceColor.White),
    PiecePosition(PieceType.Pawn, "c2", PieceColor.White),
    PiecePosition(PieceType.Pawn, "d2", PieceColor.White),
    PiecePosition(PieceType.Pawn, "e2", PieceColor.White),
    PiecePosition(PieceType.Pawn, "f2", PieceColor.White),
    PiecePosition(PieceType.Pawn, "g2", PieceColor.White),
    PiecePosition(PieceType.Pawn, "h2", PieceColor.White),
  ],
  "move": [
    PieceMove("e2", "e4"),
    PieceMove("d7", "d5"),
    PieceMove("e4", "d5"),
    PieceMove("a7", "a5"),
    PieceMove("h2", "h4"),
    PieceMove("a5", "a4"),
    PieceMove("h4", "h5"),
  ]
};

final checkmateEvent = {
  "fen": [
    PiecePosition(PieceType.King, "c8", PieceColor.Black),
    PiecePosition(PieceType.King, "h2", PieceColor.White),
    PiecePosition(PieceType.Pawn, "g2", PieceColor.White),
    PiecePosition(PieceType.Pawn, "f7", PieceColor.Black),
    PiecePosition(PieceType.Pawn, "g7", PieceColor.Black),
    PiecePosition(PieceType.Bishop, "b5", PieceColor.White),
    PiecePosition(PieceType.Bishop, "b6", PieceColor.Black),
    PiecePosition(PieceType.Rook, "b2", PieceColor.Black),
    PiecePosition(PieceType.Queen, "f2", PieceColor.Black),
    PiecePosition(PieceType.Queen, "d6", PieceColor.White),
  ],
  "move": [
    PieceMove("b5", "a6"),
  ]
};

final castlingEvent = {
  "fen": [],
  "move": [
    PieceMove("d2", "d4"),
    PieceMove("e7", "e5"),
    PieceMove("c1", "e3"),
    PieceMove("f8", "e7"),
    PieceMove("d1", "d2"),
    PieceMove("g8", "f6"),
    PieceMove("b1", "a3"),
    PieceMove("e8", "g8"),
    PieceMove("e1", "c1"),
  ]
};

final stalemateEvent = {
  "fen": [
    PiecePosition(PieceType.King, "h8", PieceColor.Black),
    PiecePosition(PieceType.King, "f7", PieceColor.White),
    PiecePosition(PieceType.Queen, "g6", PieceColor.White),
  ],
  "move": []
};

List<ChessPiece> pieces = [
  ChessPiece(
      "King",
      WhiteKing(
        size: pieceSize,
      ),
      "The king moves one square in any direction.",
      kingEvent,
      true),
  ChessPiece(
      "Rook",
      WhiteRook(
        size: pieceSize,
      ),
      "The rook can move any number of squares along a rank or file, but cannot leap over other pieces.",
      rookEvent,
      true),
  ChessPiece(
      "Bishop",
      WhiteBishop(
        size: pieceSize,
      ),
      "The bishop can move any number of squares diagonally, but cannot leap over other pieces.",
      bishopEvent,
      true),
  ChessPiece(
      "Knight",
      WhiteKnight(
        size: pieceSize,
      ),
      "The knight moves to any of the closest squares that are not on the same rank, file, or diagonal, thus the move forms an 'L'-shape: two squares vertically and one square horizontally, or two squares horizontally and one square vertically. The knight is the only piece that can leap over other pieces.",
      knightEvent,
      true),
  ChessPiece(
      "Queen",
      WhiteQueen(
        size: pieceSize,
      ),
      "The queen combines the power of a rook and bishop and can move any number of squares along a rank, file, or diagonal, but cannot leap over other pieces.",
      queenEvent,
      true),
  ChessPiece(
      "Pawn",
      WhitePawn(
        size: pieceSize,
      ),
      "Unlike the other pieces, pawns cannot move backwards. Normally a pawn moves by advancing a single square, but the first time a pawn moves, it has the option of advancing two squares. Pawns may not use the initial two-square advance to jump over an occupied square, or to capture.",
      pawnEvent,
      true),
  ChessPiece(
      "Checkmate",
      BlackKing(
        size: pieceSize,
      ),
      "Checkmate (often shortened to mate) is a game position in chess and other chess-like games in which a player's king is in check (threatened with capture ) and there is no way to avoid the threat. Checkmating the opponent wins the game.",
      checkmateEvent,
      true),
  ChessPiece(
      "Castling",
      BlackRook(
        size: pieceSize,
      ),
      "Castling is the only time in chess that two pieces can move at once, and the only time a piece other than the knight can move over another piece. The king moves two spaces to the left or to the right, and the rook moves over and in front of the king, all in one move!",
      castlingEvent,
      false),
  ChessPiece(
      "Stalemate",
      BlackQueen(
        size: pieceSize,
      ),
      "Stalemate is a situation in the game of chess where the player whose turn it is to move is not in check but has no legal move. The rules of chess provide that when stalemate occurs, the game ends as a draw.",
      stalemateEvent,
      true),
];

class ChessPiece {
  final String name;
  final Widget pieceWidget;
  final String information;
  final future;
  final bool clear;

  ChessPiece(
      this.name, this.pieceWidget, this.information, this.future, this.clear);
}

class PiecePosition {
  final type;
  final String cell;
  final color;

  PiecePosition(this.type, this.cell, this.color);
}

class PieceMove {
  final String from;
  final String to;

  PieceMove(this.from, this.to);
}
