import 'package:dio/dio.dart';
import 'package:football/model/fixture.dart';
import 'package:football/model/standing.dart';

class FootballApiService {
  final Dio _dio = Dio();
 final headers = {
      'x-rapidapi-host': "v3.football.api-sports.io",
      'x-rapidapi-key': ""
    };
  Future<List<Fixture>> getFixtures(int leagueNumber) async {
   

    final response = await _dio.get(
      "https://v3.football.api-sports.io/fixtures?season=2023&league=$leagueNumber",
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      List<dynamic> fixturesJson = response.data['response'];
      return fixturesJson.map((json) => Fixture.fromJson(json)).toList();
    } else {
      throw Exception("Error fetching fixtures: ${response.statusCode}");
    }
  }

  Future<LeagueStandings> getStandings(int leagueNumber) async {

  final response = await _dio.get(
    "https://v3.football.api-sports.io/standings?season=2023&league=$leagueNumber",
    options: Options(headers: headers),
  );

  if (response.statusCode == 200) {
    StandingsResponse standingsResponse = StandingsResponse.fromJson(response.data);
    return standingsResponse.league;
  } else {
    throw Exception("Error fetching standings: ${response.statusCode}");
  }
}

}
