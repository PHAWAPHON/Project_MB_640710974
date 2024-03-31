import 'package:flutter/material.dart';
//import 'package:football/model/fixture.dart';
//import 'package:football/apiService1.dart';
import 'package:football/matches.dart';
import 'package:football/score.dart';

var kBottomBarBackgroundColor = Colors.purple[800];
var kBottomBarForegroundActiveColor = Colors.white;
var kBottomBarForegroundInactiveColor = Colors.white60;
var kSplashColor = Colors.purple[600];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _handleClickButton(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Football App',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kBottomBarBackgroundColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBottomBarBackgroundColor,
        onPressed: () => _handleClickButton(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.live_tv, color: Colors.white),
            SizedBox(height: 5),
            Text(
              'Matches',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 64.0,
        padding: EdgeInsets.zero,
        color: kBottomBarBackgroundColor,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: AppBottomMenuItem(
                iconData: Icons.list_alt,
                text: 'Scoreboard',
                isSelected: _selectedIndex == 1,
                onClick: () => _handleClickButton(1), 
              ),
            ),
            const SizedBox(width: 100.0),
            Expanded(
              child: AppBottomMenuItem(
                iconData: Icons.person,
                text: 'Top Score',
                isSelected: _selectedIndex == 2,
                onClick: () {}, 
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children:  [
          FixturesTable(),
          StandingsTable(), 
        ],
      ),
    );
  }
}


class AppBottomMenuItem extends StatelessWidget {
  AppBottomMenuItem({
    super.key,
    required this.iconData,
    required this.text,
    required this.isSelected,
    required this.onClick,
  });

  final IconData iconData;
  final String text;
  final bool isSelected;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var color = isSelected
        ? kBottomBarForegroundActiveColor
        : kBottomBarForegroundInactiveColor;

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(iconData, color: color),
              SizedBox(height: 4.0),
              Text(
                text,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium!.copyWith(
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
