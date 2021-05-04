import 'package:flutter/material.dart';
import 'package:chess_app/widget/section_card.dart';

class OnlineMainScreen extends StatefulWidget {
  @override
  _OnlineMainScreenState createState() => _OnlineMainScreenState();
}

class _OnlineMainScreenState extends State<OnlineMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Online Play"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    SectionCard(
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            "assets/images/create_game.jpeg",
                            width: 100,
                            height: 100,
                          ),
                        ),
                        "Create a new game",
                        "Create a new game with a unique ID for others to join.",
                        () {
                      Navigator.pushNamed(context, '/online_chess/create');
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    SectionCard(
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            "assets/images/join_game.jpeg",
                            width: 100,
                            height: 100,
                          ),
                        ),
                        "Join a game",
                        "Join a game by ID", () {
                      Navigator.pushNamed(context, '/online_chess/join');
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    SectionCard(
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            "assets/images/watch_game.jpg",
                            width: 100,
                            height: 100,
                          ),
                        ),
                        "Spectate a game",
                        "Watch a game by ID", () {
                      Navigator.pushNamed(context, '/online_chess/watch');
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
