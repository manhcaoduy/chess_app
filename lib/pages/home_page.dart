import 'package:flutter/material.dart';
import 'package:chess_app/widget/section_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Container(
              color: Theme.of(context).primaryColor,
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/chess_logo.jpg',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(100.0)),
      body: SafeArea(
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SectionCard(
                        Image.asset(
                          'assets/images/learn.jpeg',
                          width: 100,
                          height: 100,
                        ),
                        "Learn",
                        "Explore how chess pieces move on a chessboard", () {
                      Navigator.pushNamed(context, '/pieces_page');
                    }),
                    SectionCard(
                        Image.asset(
                          'assets/images/computer.jpg',
                          width: 100,
                          height: 100,
                        ),
                        "Computer",
                        "Play with the computer", () {
                      Navigator.pushNamed(context, '/computer_play');
                    }),
                    SectionCard(
                        Image.asset(
                          'assets/images/offline.jpg',
                          width: 100,
                          height: 100,
                        ),
                        "Offline Play",
                        "Play with friends on the same device", () {
                      Navigator.pushNamed(context, '/two_players');
                    }),
                    SectionCard(
                        Image.asset(
                          'assets/images/online.png',
                          width: 100,
                          height: 100,
                        ),
                        "Online Play",
                        "Play with friends on the different device", () {
                      Navigator.pushNamed(context, '/online_chess');
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
