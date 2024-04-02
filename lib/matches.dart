import 'package:flutter/material.dart';
import 'package:football/model/fixture.dart';
import 'package:football/apiService1.dart';
import '../tabbar/customtabbar.dart';

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
          icons: [Icons.home, Icons.settings, Icons.abc, Icons.abc, Icons.abc],
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
  Widget _buildTeamSection(String logoUrl, String teamName, {bool isHomeTeam = true}) {
  return Expanded(
    child: Row(
      mainAxisAlignment: isHomeTeam ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (isHomeTeam) ...[
          Image.network(logoUrl, height: 50, width: 50, fit: BoxFit.cover),
          SizedBox(width: 10),
        ],
        Expanded(
          child: Text(
            teamName,
            style: TextStyle(color: Colors.white,fontSize: 16, fontWeight: FontWeight.bold),
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
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (showDate)
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
          child: Text(
            '${fixture.date.day}/${fixture.date.month}/${fixture.date.year}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                  
                  _buildTeamSection(fixture.teams.home.logo, fixture.teams.home.name),
                 
                  _buildMiddleSection(fixture),
                
                  _buildTeamSection(fixture.teams.away.logo, fixture.teams.away.name, isHomeTeam: false),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
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
