import 'package:flutter/material.dart';

import 'package:football/matches.dart';
import 'package:football/score.dart';
import 'package:football/cardPlayer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    FixturesTable(),
    StandingsTable(),
    Players(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(
        onItemSelected: _onItemTapped,
      ),
      appBar: AppBar(
          title: Text('Football App', style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromARGB(240, 0, 0, 0)),
      body: _pages[_selectedIndex],
    );
  }
}

class NavigationDrawerWidget extends StatelessWidget {
  final Function(int) onItemSelected;
  final EdgeInsets padding = EdgeInsets.symmetric(horizontal: 15);

  final String userName = "แอนโทนี่";
  final String userEmail = "เดอะหมุน@หมุนแล้วยิง.com";

  NavigationDrawerWidget({required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color.fromARGB(255, 28, 17, 17),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('anthony.png'),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8),
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: null,
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  SizedBox(height: 10),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Matches',
                    icon: Icons.dashboard,
                    onClicked: () => onItemSelected(0),
                  ),
                  SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Scoreboard',
                    icon: Icons.sports_soccer,
                    onClicked: () => onItemSelected(1),
                  ),
                  SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Player Stats',
                    icon: Icons.table_chart,
                    onClicked: () => onItemSelected(2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.pink;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}
