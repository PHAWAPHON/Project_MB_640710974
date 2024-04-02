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
    Text('Table'),
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
  final padding = EdgeInsets.symmetric(horizontal: 20);

  NavigationDrawerWidget({required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color.fromARGB(255, 28, 17, 17),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: ListView(
            children: <Widget>[
              buildMenuItem(
                text: 'Overview',
                icon: Icons.dashboard,
                onClicked: () => onItemSelected(0),
              ),
              SizedBox(
                height: 10,
              ),
              buildMenuItem(
                text: 'Matches',
                icon: Icons.sports_soccer,
                onClicked: () => onItemSelected(1),
              ),
              SizedBox(
                height: 10,
              ),
              buildMenuItem(
                text: 'Table',
                icon: Icons.table_chart,
                onClicked: () => onItemSelected(2),
              ),
              SizedBox(
                height: 10,
              ),
              buildMenuItem(
                text: 'News',
                icon: Icons.newspaper,
                onClicked: () => onItemSelected(3),
              ),
            ],
          ),
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
