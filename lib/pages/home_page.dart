import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class SectionCard extends StatelessWidget {
  final Widget logo;
  final String title;
  final String description;
  final GestureTapCallback onTap;

  SectionCard(this.logo, this.title, this.description, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 4.0,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: <Widget>[
                logo,
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          description,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
