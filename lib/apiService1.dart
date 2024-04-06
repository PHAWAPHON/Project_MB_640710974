import 'package:dio/dio.dart';
import 'package:football/model/fixture.dart';
import 'package:football/model/standing.dart';
import 'package:football/model/stats.dart';
import 'package:football/model/player.dart';

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
      StandingsResponse standingsResponse =
          StandingsResponse.fromJson(response.data);
      return standingsResponse.league;
    } else {
      throw Exception("Error fetching standings: ${response.statusCode}");
    }
  }

  Future<List<MatchStats>> getStaticFixtures(int fixture, int team) async {
    try {
      final response = await _dio.get(
        "https://v3.football.api-sports.io/fixtures/statistics",
        queryParameters: {
          'fixture': fixture.toString(),
          'team': team.toString(),
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        List<dynamic> fixturesJson = response.data['response'];
        if (fixturesJson.isNotEmpty) {
          List<MatchStats> statsList =
              fixturesJson.map((json) => MatchStats.fromJson(json)).toList();
          print('Statistics: $statsList');
          return statsList;
        } else {
          print('No statistics found');
          return [];
        }
      } else {
        print('Error fetching statistics: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('An error occurred: $e');
      return [];
    }
  }

  Future<List<TopScorer>> getTop(String tops, int leagueNumber) async {
    final response = await _dio.get(
      "https://v3.football.api-sports.io/players/$tops?season=2023&league=$leagueNumber",
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      List<dynamic> topScorersData = response.data['response'];
      List<TopScorer> topScorers =
          topScorersData.map((json) => TopScorer.fromJson(json)).toList();
      return topScorers;
    } else {
      throw Exception("Error fetching top scorers: ${response.statusCode}");
    }
  }
}
