// Computer Play
class ComputerEndgameAction {
  String endgameMessenge;
  String fen;
  ComputerEndgameAction({this.endgameMessenge, this.fen});
}

class ComputerUpdateFen {
  String newFen;
  ComputerUpdateFen(this.newFen);
}

class ComputerRestartAction {}
