import 'package:flutter/material.dart';
import 'package:football/apiService1.dart';
import 'package:football/model/standing.dart';
import '../tabbar/customtabbar.dart';

class StandingsTable extends StatefulWidget {
  @override
  _StandingsTableState createState() => _StandingsTableState();
}

class _StandingsTableState extends State<StandingsTable> {
  late Future<LeagueStandings> _standingsFuture;
  int currentTabIndex = 0;
  final List<int> leagueNumbers = [39, 140, 78, 135, 61];

  @override
  void initState() {
    super.initState();
    _standingsFuture = FootballApiService().getStandings(leagueNumbers[0]);
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
              _standingsFuture =
                  FootballApiService().getStandings(leagueNumbers[index]);
            });
          },
        ),
      ),
      body: IndexedStack(
        index: currentTabIndex,
        children: [
          _buildStandingsView(),
          _buildStandingsView(),
          _buildStandingsView(),
          _buildStandingsView(),
          _buildStandingsView(),
        ],
      ),
    );
  }

  Widget _buildStandingsView() {
    return FutureBuilder<LeagueStandings>(
      future: _standingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.grey[800],
                        dataTableTheme: DataTableThemeData(
                          dividerThickness: 0.5,
                        ),
                      ),
                      child: Container(
                        color: Color.fromARGB(240, 0, 0, 0),
                        child: DataTable(
                          columns: _createColumns(),
                          rows: _createRows(snapshot.data!.standings[0]),
                          columnSpacing: 12.0,
                          headingRowHeight: 56,
                          headingTextStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          dataTextStyle: TextStyle(color: Colors.white),
                          showCheckboxColumn: false,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text("No data available"));
        }
      },
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('#')),
      DataColumn(label: Text('TEAM')),
      DataColumn(label: Text('P'), numeric: true),
      DataColumn(label: Text('W'), numeric: true), 
      DataColumn(label: Text('D'), numeric: true),
      DataColumn(label: Text('L'), numeric: true), 
      DataColumn(label: Text('GD'), numeric: true), 
      DataColumn(label: Text('PTS'), numeric: true),
    ];
  }

  List<DataRow> _createRows(List<TeamStanding> standings) {
    return standings.map((teamStanding) {
      return DataRow(
        cells: [
          DataCell(Text('${teamStanding.rank}',
              style: TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Row(children: [
            Image.network(teamStanding.team.logo, width: 40, height: 40),
            SizedBox(width: 10),
            Text(teamStanding.team.name,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ])),
          DataCell(Text('${teamStanding.all.played}',
              style: TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text('${teamStanding.all.win}',
              style: TextStyle(fontWeight: FontWeight.bold))), 
          DataCell(Text('${teamStanding.all.draw}',
              style: TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text('${teamStanding.all.lose}',
              style: TextStyle(fontWeight: FontWeight.bold))), 
          DataCell(Text('${teamStanding.goalsDiff}',
              style:
                  TextStyle(fontWeight: FontWeight.bold))), 
          DataCell(Text('${teamStanding.points}',
              style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      );
    }).toList();
  }
}
