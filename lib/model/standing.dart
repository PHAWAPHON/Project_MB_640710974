class StandingsResponse {
  final LeagueStandings league;

  StandingsResponse({required this.league});

  factory StandingsResponse.fromJson(Map<String, dynamic> json) {
    return StandingsResponse(
      league: LeagueStandings.fromJson(json['response']?[0]['league'] ?? {}),
    );
  }
}

class LeagueStandings {
  final int id;
  final String name;
  final String country;
  final String logo;
  final String flag;
  final int season;
  final List<List<TeamStanding>> standings;

  LeagueStandings({
    required this.id,
    required this.name,
    required this.country,
    required this.logo,
    required this.flag,
    required this.season,
    required this.standings,
  });

  factory LeagueStandings.fromJson(Map<String, dynamic> json) {
    return LeagueStandings(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      logo: json['logo'] ?? '',
      flag: json['flag'] ?? '',
      season: json['season'] ?? 0,
      standings: (json['standings'] as List? ?? [])
          .map((e) => (e as List? ?? [])
              .map((team) => TeamStanding.fromJson(team))
              .toList())
          .toList(),
    );
  }
}

class TeamStanding {
  final int rank;
  final Team team;
  final int points;
  final int goalsDiff;
  final String group;
  final String form;
  final String status;
  final String description;
  final TeamPerformance all;

  TeamStanding({
    required this.rank,
    required this.team,
    required this.points,
    required this.goalsDiff,
    required this.group,
    required this.form,
    required this.status,
    required this.description,
    required this.all, 
  });

  factory TeamStanding.fromJson(Map<String, dynamic> json) {
    return TeamStanding(
      rank: json['rank'] ?? 0,
      team: Team.fromJson(json['team'] ?? {}),
      points: json['points'] ?? 0,
      goalsDiff: json['goalsDiff'] ?? 0,
      group: json['group'] ?? '',
      form: json['form'] ?? '',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      all: TeamPerformance.fromJson(json['all']), 
    );
  }
}


class Team {
  final int id;
  final String name;
  final String logo;

  Team({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}
class TeamPerformance {
  final int played;
  final int win;
  final int draw;
  final int lose;
  final Map<String, int> goals;

  TeamPerformance({
    required this.played,
    required this.win,
    required this.draw,
    required this.lose,
    required this.goals,
  });

  factory TeamPerformance.fromJson(Map<String, dynamic> json) {
    return TeamPerformance(
      played: json['played'] ?? 0,
      win: json['win'] ?? 0,
      draw: json['draw'] ?? 0,
      lose: json['lose'] ?? 0,
      goals: {
        'for': json['goals']['for'] ?? 0,
        'against': json['goals']['against'] ?? 0,
      },
    );
  }
}



