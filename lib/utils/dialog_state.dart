int dialogState(String endgameMessenge) {
  if (endgameMessenge.contains("Draw")) return 2;
  if (endgameMessenge.contains("White wins")) return 0;
  return 1;
}
