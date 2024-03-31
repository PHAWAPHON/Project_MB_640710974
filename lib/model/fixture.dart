class Venue {
  final int id;
  final String name;
  final String city;

  Venue({
    required this.id,
    required this.name,
    required this.city,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] == null ? 0 : json['id'] as int,
      name: json['name'] == null ? '' : json['name'] as String,
      city: json['city'] == null ? '' : json['city'] as String,
    );
  }
}

class Status {
  final String long;
  final String short;
  final int elapsed;

  Status({
    required this.long,
    required this.short,
    required this.elapsed,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      long: json['long'] == null ? '' : json['long'] as String,
      short: json['short'] == null ? '' : json['short'] as String,
      elapsed: json['elapsed'] == null ? 0 : json['elapsed'] as int,
    );
  }
}

class League {
  final int id;
  final String name;
  final String country;
  final String logo;
  final String flag;
  final int season;
  final String round;

  League({
    required this.id,
    required this.name,
    required this.country,
    required this.logo,
    required this.flag,
    required this.season,
    required this.round,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'] == null ? 0 : json['id'] as int,
      name: json['name'] == null ? '' : json['name'] as String,
      country: json['country'] == null ? '' : json['country'] as String,
      logo: json['logo'] == null ? '' : json['logo'] as String,
      flag: json['flag'] == null ? '' : json['flag'] as String,
      season: json['season'] == null ? 0 : json['season'] as int,
      round: json['round'] == null ? '' : json['round'] as String,
    );
  }
}

class Teams {
  final Team home;
  final Team away;

  Teams({
    required this.home,
    required this.away,
  });

  factory Teams.fromJson(Map<String, dynamic> json) {
    return Teams(
      home: Team.fromJson(json['home']),
      away: Team.fromJson(json['away']),
    );
  }
}

class Team {
  final int id;
  final String name;
  final String logo;
  final bool? winner;

  Team({
    required this.id,
    required this.name,
    required this.logo,
    this.winner,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] == null ? 0 : json['id'] as int,
      name: json['name'] == null ? '' : json['name'] as String,
      logo: json['logo'] == null ? '' : json['logo'] as String,
      winner: json['winner'] == null ? false : json['winner'] as bool,
    );
  }
}

class Goals {
  final int home;
  final int away;

  Goals({
    required this.home,
    required this.away,
  });

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      home: json['home'] == null ? 0 : json['home'] as int,
      away: json['away'] == null ? 0 : json['away'] as int,
    );
  }
}

class Score {
  final ScoreDetail halftime;
  final ScoreDetail fulltime;
  final ScoreDetail extratime;
  final ScoreDetail penalty;

  Score({
    required this.halftime,
    required this.fulltime,
    required this.extratime,
    required this.penalty,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      halftime: ScoreDetail.fromJson(json['halftime']),
      fulltime: ScoreDetail.fromJson(json['fulltime']),
      extratime: ScoreDetail.fromJson(json['extratime']),
      penalty: ScoreDetail.fromJson(json['penalty']),
    );
  }
}

class ScoreDetail {
  final int home;
  final int away;

  ScoreDetail({
    required this.home,
    required this.away,
  });

  factory ScoreDetail.fromJson(Map<String, dynamic> json) {
    return ScoreDetail(
      home: json['home'] == null ? 0 : json['home'] as int,
      away: json['away'] == null ? 0 : json['away'] as int,
    );
  }
}

class Event {
  final int time;
  final Team team;
  final String type;
  final String detail;
  final Player player;
  final Player assist;
  final Player? comments;

  Event({
    required this.time,
    required this.team,
    required this.type,
    required this.detail,
    required this.player,
    required this.assist,
    this.comments,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      time: json['time'] ?? 0,
      team: Team.fromJson(json['team']),
      type: json['type'] ?? '',
      detail: json['detail'] ?? '',
      player: Player.fromJson(json['player']),
      assist: Player.fromJson(json['assist']),
      comments:
          json['comments'] != null ? Player.fromJson(json['comments']) : null,
    );
  }
}

class Player {
  final int id;
  final String name;

  Player({
    required this.id,
    required this.name,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class Fixture {
  final int id;
  final String? referee;
  final String timezone;
  final DateTime date;
  final int timestamp;
  final Map<String, int> periods;
  final Venue venue;
  final Status status;
  final League league;
  final Teams teams;
  final Goals goals;
  final Score score;
  final List<Event> events;

  Fixture({
    required this.id,
    this.referee,
    required this.timezone,
    required this.date,
    required this.timestamp,
    required this.periods,
    required this.venue,
    required this.status,
    required this.league,
    required this.teams,
    required this.goals,
    required this.score,
    required this.events,
  });

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      id: json['fixture']['id'] ?? 0,
      referee: json['fixture']['referee'],
      timezone: json['fixture']['timezone'] ?? '',
      date: DateTime.parse(json['fixture']['date']),
      timestamp: json['fixture']['timestamp'] ?? 0,
      periods: Map<String, int>.from(json['fixture']['periods']),
      venue: Venue.fromJson(json['fixture']['venue']),
      status: Status.fromJson(json['fixture']['status']),
      league: League.fromJson(json['league']),
      teams: Teams.fromJson(json['teams']),
      goals: Goals.fromJson(json['goals']),
      score: Score.fromJson(json['score']),
      events: (json['events'] as List? ?? []).map((e) => Event.fromJson(e)).toList(),
    );
  }
}
