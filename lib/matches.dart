import 'package:flutter/material.dart';
import 'package:football/model/fixture.dart';
import 'package:football/apiService1.dart';

class FixturesTable extends StatefulWidget {
  @override
  _FixturesTableState createState() => _FixturesTableState();
}

class _FixturesTableState extends State<FixturesTable> {
  late Future<List<Fixture>> _fixturesFuture;

  @override
  void initState() {
    super.initState();
    _fixturesFuture = FootballApiService().getFixtures();
  }

  Widget _buildFixtureCard(Fixture fixture) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 8.0),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 50,
            width: 50,  
            child: Image.network(fixture.teams.home.logo, fit: BoxFit.cover),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  fixture.date.day.toString() + '/' + fixture.date.month.toString() + '/' + fixture.date.year.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  '${fixture.teams.home.name} vs ${fixture.teams.away.name}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
          SizedBox(
            height: 50, 
            width: 50, 
            child: Image.network(fixture.teams.away.logo, fit: BoxFit.cover),
          ),
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Fixture>>(
      future: _fixturesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return _buildFixtureCard(snapshot.data![index]);
            },
          );
        } else {
          return Center(child: Text("No data available"));
        }
      },
    );
  }
}
