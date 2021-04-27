import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chess_app/pages/home_page.dart';

class OnlineMainScreen extends StatefulWidget {
  @override
  _OnlineMainScreenState createState() => _OnlineMainScreenState();
}

class _OnlineMainScreenState extends State<OnlineMainScreen> {
  var titleFontSize = 24.0;

  void _changeStatusBarColor() async {
    // await FlutterStatusbarManager.setHidden(true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Theme.of(context).platform == TargetPlatform.android) {
      _changeStatusBarColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 36.0),
                            child: FlutterLogo(
                              size: 30.0,
                            ),
                          ),
                          Text(
                            "Online Chess",
                            style: TextStyle(fontSize: 30.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SectionTitle("Create a new game"),
                    SectionCard(
                        Icon(Icons.create, size: 30.0),
                        Text(
                          "Create a new game with a unique ID for others to join.",
                          style: TextStyle(fontSize: 18.0),
                        ), () {
                      Navigator.pushNamed(context, '/online_chess/create');
                    }),
                    SectionTitle("Join a game"),
                    SectionCard(
                        WhitePawn(
                          size: 80.0,
                        ),
                        Text(
                          "Join a game by ID",
                          style: TextStyle(fontSize: 18.0),
                        ), () {
                      Navigator.pushNamed(context, '/online_chess/join');
                    }),
                    SectionTitle("Spectate a game"),
                    SectionCard(
                        WhitePawn(
                          size: 80.0,
                        ),
                        Text(
                          "Watch a game by ID",
                          style: TextStyle(fontSize: 18.0),
                        ), () {
                      Navigator.pushNamed(context, '/online_chess/watch');
                    }),
                  ],
                ),
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
