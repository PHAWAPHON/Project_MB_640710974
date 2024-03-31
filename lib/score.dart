import 'package:flutter/material.dart';
import 'package:football/apiService1.dart';
import 'package:football/model/standing.dart';

class StandingsTable extends StatefulWidget {
  @override
  _StandingsTableState createState() => _StandingsTableState();
}

class _StandingsTableState extends State<StandingsTable> {
  late Future<LeagueStandings> _standingsFuture;

  @override
  void initState() {
    super.initState();
    _standingsFuture = FootballApiService().getStandings();
  }

 @override
Widget build(BuildContext context) {
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
                  child: DataTable(
                    columns: _createColumns(),
                    rows: _createRows(snapshot.data!.standings[0]),
                    columnSpacing: 12.0,
                    headingRowHeight: 56,
                    headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    showCheckboxColumn: false,
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
      DataColumn(label: Text('GD'), numeric: true),
      DataColumn(label: Text('PTS'), numeric: true),
    ];
  }

  List<DataRow> _createRows(List<TeamStanding> standings) {
    return standings.map((teamStanding) {
      return DataRow(
        cells: [
          DataCell(Text('${teamStanding.rank}')),
          DataCell(
            Row(
              children: [
                Image.network(teamStanding.team.logo),
                SizedBox(width: 10),
                Text(teamStanding.team.name),
              ],
            ),
          ),
          DataCell(Text('${teamStanding.all.played}')),
          DataCell(Text('${teamStanding.goalsDiff}')),
          DataCell(Text('${teamStanding.points}')),
        ],
      );
    }).toList();
  }
}
