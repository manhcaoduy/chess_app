class ComputerPlayState {
  String fen;
  bool isGameOver;
  String endgameResult;

  ComputerPlayState({
    this.fen,
    this.isGameOver,
    this.endgameResult,
  });

  ComputerPlayState.initialState()
      : fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
        isGameOver = false,
        endgameResult = '';
}

class AppState {
  ComputerPlayState computerPlay;

  AppState({
    this.computerPlay,
  });

  AppState.initialState() : computerPlay = ComputerPlayState.initialState();
}
