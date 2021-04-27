import 'package:chess/chess.dart' as ch;

// New fen after doing a move
String makeMove(String fen, dynamic move) {
  final chess = ch.Chess.fromFEN(fen);

  if (chess.move(move)) {
    return chess.fen;
  }

  return null;
}

// Generate random move from package chess.dart
String getRandomMove(String fen) {
  final chess = ch.Chess.fromFEN(fen);

  final moves = chess.moves();

  if (moves.isEmpty) {
    return null;
  }

  moves.shuffle();

  return moves.first;
}
