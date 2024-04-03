import 'dart:math';

import 'package:flutter/material.dart';
import 'package:football/model/fixture.dart';
import 'package:football/apiService1.dart';
import '../tabbar/customtabbar.dart';
import '../model/stats.dart';

class FixturesTable extends StatefulWidget {
  @override
  _FixturesTableState createState() => _FixturesTableState();
}

class _FixturesTableState extends State<FixturesTable> {
  late Future<List<Fixture>> _fixturesFuture;
  int currentTabIndex = 0;
  final List<int> leagueNumbers = [39, 140, 78, 135, 61];

  @override
  void initState() {
    super.initState();
    _fixturesFuture = FootballApiService().getFixtures(leagueNumbers[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomTabBar(
          items: [
            'Premier League',
            'Laliga',
            'Bundesliga',
            'Serie A',
            'Ligue 1'
          ],
    
          onTabChanged: (index) {
            setState(() {
              currentTabIndex = index;
              _fixturesFuture =
                  FootballApiService().getFixtures(leagueNumbers[index]);
            });
          },
        ),
      ),
      body: IndexedStack(
        index: currentTabIndex,
        children: [
          _buildFixturesView(),
          _buildFixturesView(),
          _buildFixturesView(),
          _buildFixturesView(),
          _buildFixturesView(),
        ],
      ),
    );
  }

  Widget _buildFixturesView() {
    return FutureBuilder<List<Fixture>>(
      future: _fixturesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          Fixture firstFixture = snapshot.data!.first;
          return ListView(
            children: [
              for (int index = 0; index < snapshot.data!.length; index++)
                _buildFixtureCard(snapshot.data![index],
                    shouldShowTime(index, snapshot.data!, firstFixture))
            ],
          );
        } else {
          return Center(child: Text("No data available"));
        }
      },
    );
  }

  bool shouldShowTime(int index, List<Fixture> fixtures, Fixture firstFixture) {
    if (index == 0) return true;

    Fixture prevFixture = fixtures[index - 1];
    return fixtures[index].date.hour != prevFixture.date.hour ||
        fixtures[index].date.minute != prevFixture.date.minute ||
        (fixtures[index].date.day != firstFixture.date.day &&
            fixtures[index].date.month != firstFixture.date.month);
  }

  Widget _buildTeamSection(String logoUrl, String teamName,
      {bool isHomeTeam = true}) {
    return Expanded(
      child: Row(
        mainAxisAlignment:
            isHomeTeam ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isHomeTeam) ...[
            Image.network(logoUrl, height: 50, width: 50, fit: BoxFit.cover),
            SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              teamName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: isHomeTeam ? TextAlign.left : TextAlign.right,
            ),
          ),
          if (!isHomeTeam) ...[
            SizedBox(width: 10),
            Image.network(logoUrl, height: 50, width: 50, fit: BoxFit.cover),
          ],
        ],
      ),
    );
  }

  Widget _buildFixtureCard(Fixture fixture, bool showDate) {
    return GestureDetector(
      onTap: () {
        if (fixture.teams.home.id != null && fixture.teams.away.id != null) {
          _showStatsDialog(context, fixture);
        } else {}
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showDate)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Text(
                '${fixture.date.day}/${fixture.date.month}/${fixture.date.year}',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            color: Color.fromARGB(255, 28, 17, 17),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTeamSection(
                          fixture.teams.home.logo, fixture.teams.home.name),
                      _buildMiddleSection(fixture),
                      _buildTeamSection(
                          fixture.teams.away.logo, fixture.teams.away.name,
                          isHomeTeam: false),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiddleSection(Fixture fixture) {
    if (fixture.status.short == "FT") {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'FT',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            '${fixture.goals.home ?? 0} - ${fixture.goals.away ?? 0}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else {
      String text = fixture.status.short == "NS"
          ? '${fixture.date.hour.toString().padLeft(2, '0')}:${fixture.date.minute.toString().padLeft(2, '0')}'
          : '${fixture.goals.home ?? 0} - ${fixture.goals.away ?? 0}';

      return Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      );
    }
  }

  bool shouldShowDate(int index, List<Fixture> fixtures, Fixture firstFixture) {
    if (index == 0) return true;
    Fixture prevFixture = fixtures[index - 1];
    return fixtures[index].date.day != prevFixture.date.day ||
        fixtures[index].date.month != prevFixture.date.month;
  }
}

void _showStatsDialog(BuildContext context, Fixture fixture) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Match Statistics',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set text color to white
                  ),
                ),
                SizedBox(height: 16.0),
                FutureBuilder<List<List<MatchStats>>>(
                  future: Future.wait([
                    FootballApiService().getStaticFixtures(
                        fixture.id!, fixture.teams.home.id!),
                    FootballApiService().getStaticFixtures(
                        fixture.id!, fixture.teams.away.id!)
                  ]),
                  builder: (context,
                      AsyncSnapshot<List<List<MatchStats>>> snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}',
                          style: TextStyle(color: Colors.red)); // Set error text color to red
                    } else if (snapshot.hasData && snapshot.data!.length == 2) {
                      var homeStats = snapshot.data![0];
                      var awayStats = snapshot.data![1];
                      if (homeStats.isNotEmpty && awayStats.isNotEmpty) {
                        return _buildStatsComparisonView(
                            context, homeStats.first, awayStats.first);
                      } else {
                        return Text("Incomplete statistics available",
                            style: TextStyle(color: Colors.white));
                      }
                    } else {
                      return Text("No statistics available",
                          style: TextStyle(color: Colors.white));
                    }
                  },
                ),
                SizedBox(height: 16.0),
                TextButton(
                  child: Text('Close', style: TextStyle(color: Colors.white)), // Set button text color to white
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
        scrollable: false,
      );
    },
  );
}

Widget _buildStatsComparisonView(
  BuildContext context, MatchStats homeStats, MatchStats awayStats) {
  
  List<Widget> statsWidgets = homeStats.statistics.keys.map((statKey) {
    double homeValue = parseStatValue(homeStats.statistics[statKey]);
    double awayValue = parseStatValue(awayStats.statistics[statKey]);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white), // Set border color to white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.black,
              child: Text(
                statKey,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, 
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.black,
              child: Text(
                '$homeValue - $awayValue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }).toList();

  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white), // Set border color to white
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.black,
                  child: Text(
                    'Statistic',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.black,
                  child: Text(
                    'Home - Away',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ...statsWidgets,
      ],
    ),
  );
}

double parseStatValue(dynamic value) {
  if (value is num) {
    return value.toDouble();
  } else if (value is String) {
    return double.tryParse(value.replaceAll('%', '')) ?? 0.0;
  } else {
    return 0.0;
  }
}
