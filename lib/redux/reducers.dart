import 'package:chess_app/redux/data.dart';
import 'package:chess_app/redux/actions.dart';
import 'package:redux/redux.dart';

ComputerPlayState computerEndgameReducer(ComputerPlayState state, action) {
  return ComputerPlayState(
    fen: action.fen,
    isGameOver: true,
    endgameResult: action.endgameMessenge,
  );
}

ComputerPlayState computerRestartReducer(ComputerPlayState state, action) {
  return ComputerPlayState(
    fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
    isGameOver: false,
    endgameResult: '',
  );
}

ComputerPlayState computerUpdateFenReducer(ComputerPlayState state, action) {
  return ComputerPlayState(
    fen: action.newFen,
    isGameOver: state.isGameOver,
    endgameResult: state.endgameResult,
  );
}

final Reducer<ComputerPlayState> computerReducer =
    combineReducers<ComputerPlayState>([
  new TypedReducer<ComputerPlayState, ComputerEndgameAction>(
      computerEndgameReducer),
  new TypedReducer<ComputerPlayState, ComputerRestartAction>(
      computerRestartReducer),
  new TypedReducer<ComputerPlayState, ComputerUpdateFen>(
      computerUpdateFenReducer),
]);

AppState appStateReducer(AppState state, action) {
  return AppState(
    computerPlay: computerReducer(state.computerPlay, action),
  );
}
