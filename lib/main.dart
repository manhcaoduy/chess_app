import 'package:flutter/material.dart';
import 'package:chess_app/pages/home_page.dart';
import 'package:chess_app/pages/splash_screen.dart';
import 'package:chess_app/pages/pieces_page.dart';
import 'package:chess_app/pages/computer_play.dart';
import 'package:chess_app/pages/two_players.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: Theme.of(context).platform == TargetPlatform.android
            ? "Raleway"
            : null,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomePage(),
        '/pieces_page': (context) => PiecesPage(),
        '/computer_play': (context) => ComputerPlay(),
        '/two_players': (context) => TwoPlayers(),
      },
    );
  }
}
