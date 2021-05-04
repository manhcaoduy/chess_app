import 'package:chess_app/redux/data.dart';
import 'package:chess_app/redux/reducers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chess_app/pages/home_page.dart';
import 'package:chess_app/pages/splash_screen.dart';
import 'package:chess_app/pages/pieces_page.dart';
import 'package:chess_app/pages/computer_play.dart';
import 'package:chess_app/pages/two_players.dart';
import 'package:chess_app/pages/online_chess.dart';
import 'package:chess_app/pages/OnlineChess/create.dart';
import 'package:chess_app/pages/OnlineChess/join.dart';
import 'package:chess_app/pages/OnlineChess/watch.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() async {
  // setup firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // root widget
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // setup redux store
    final Store store = Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
    );

    return StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
        title: 'Chess App',

        // set dark theme
        theme: new ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
        ),

        // start with splash screen
        home: SplashScreen(),

        // routes list
        routes: {
          '/home': (context) => HomePage(),
          '/pieces_page': (context) => PiecesPage(),
          '/computer_play': (context) => ComputerPlay(),
          '/two_players': (context) => TwoPlayers(),
          '/online_chess': (context) => OnlineMainScreen(),
          '/online_chess/create': (context) => OnlineCreateScreen(),
          '/online_chess/join': (context) => OnlineJoinScreen(),
          '/online_chess/watch': (context) => OnlineWatchScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
