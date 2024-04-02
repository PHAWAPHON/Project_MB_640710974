class Venue {
  final int? id;
  final String name;
  final String city;

  Venue({this.id, required this.name, required this.city});

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        id: json['id'],
        name: json['name'] ?? '',
        city: json['city'] ?? '',
      );
}

class Status {
  final String long;
  final String short;
  final int? elapsed;

  Status({required this.long, required this.short, this.elapsed});

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        long: json['long'] ?? '',
        short: json['short'] ?? '',
        elapsed: json['elapsed'],
      );
}

class League {
  final int? id;
  final String name;
  final String country;
  final String logo;
  final String flag;
  final int? season;
  final String round;

  League(
      {this.id,
      required this.name,
      required this.country,
      required this.logo,
      required this.flag,
      this.season,
      required this.round});

  factory League.fromJson(Map<String, dynamic> json) => League(
        id: json['id'],
        name: json['name'] ?? '',
        country: json['country'] ?? '',
        logo: json['logo'] ?? '',
        flag: json['flag'] ?? '',
        season: json['season'],
        round: json['round'] ?? '',
      );
}

class Team {
  final int? id;
  final String name;
  final String logo;
  final bool? winner;

  Team({this.id, required this.name, required this.logo, this.winner});

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json['id'],
        name: json['name'] ?? '',
        logo: json['logo'] ?? '',
        winner: json['winner'],
      );
}

class Teams {
  final Team home;
  final Team away;

  Teams({required this.home, required this.away});

  factory Teams.fromJson(Map<String, dynamic> json) => Teams(
        home: Team.fromJson(json['home']),
        away: Team.fromJson(json['away']),
      );
}

class Goals {
  final int? home;
  final int? away;

  Goals({this.home, this.away});

  factory Goals.fromJson(Map<String, dynamic> json) => Goals(
        home: json['home'],
        away: json['away'],
      );
}

class ScoreDetail {
  final int? home;
  final int? away;

  ScoreDetail({this.home, this.away});

  factory ScoreDetail.fromJson(Map<String, dynamic> json) => ScoreDetail(
        home: json['home'],
        away: json['away'],
      );
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

  factory Score.fromJson(Map<String, dynamic> json) => Score(
        halftime: ScoreDetail.fromJson(json['halftime']),
        fulltime: ScoreDetail.fromJson(json['fulltime']),
        extratime: ScoreDetail.fromJson(json['extratime']),
        penalty: ScoreDetail.fromJson(json['penalty']),
      );
}

class Player {
  final int? id;
  final String name;

  Player({this.id, required this.name});

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json['id'],
        name: json['name'] ?? '',
      );
}

class Event {
  final int? time;
  final Team team;
  final String type;
  final String detail;
  final Player player;
  final Player assist;
  final Player? comments;

  Event({
    this.time,
    required this.team,
    required this.type,
    required this.detail,
    required this.player,
    required this.assist,
    this.comments,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        time: json['time'],
        team: Team.fromJson(json['team']),
        type: json['type'] ?? '',
        detail: json['detail'] ?? '',
        player: Player.fromJson(json['player']),
        assist: Player.fromJson(json['assist']),
        comments: json['comments'] != null
            ? Player.fromJson(json['comments'])
            : null,
      );
}

class Fixture {
  final int? id;
  final String? referee;
  final String timezone;
  final DateTime date;
  final int timestamp;
  final Map<String, int>? periods;
  final Venue venue;
  final Status status;
  final League league;
  final Teams teams;
  final Goals goals;
  final Score score;
  final List<Event> events;

  Fixture({
    this.id,
    this.referee,
    required this.timezone,
    required this.date,
    required this.timestamp,
    this.periods,
    required this.venue,
    required this.status,
    required this.league,
    required this.teams,
    required this.goals,
    required this.score,
    required this.events,
  });

  factory Fixture.fromJson(Map<String, dynamic> json) => Fixture(
        id: json['fixture']['id'],
        referee: json['fixture']['referee'],
        timezone: json['fixture']['timezone'] ?? 'UTC',
        date: DateTime.parse(json['fixture']['date']),
        timestamp: json['fixture']['timestamp'] ?? 0,
        periods: (json['fixture']['periods'] as Map?)?.map(
          (key, value) => MapEntry(key, value ?? 0),
        ),
        venue: Venue.fromJson(json['fixture']['venue']),
        status: Status.fromJson(json['fixture']['status']),
        league: League.fromJson(json['league']),
        teams: Teams.fromJson(json['teams']),
        goals: Goals.fromJson(json['goals']),
        score: Score.fromJson(json['score']),
        events: List<Event>.from(
          json['events']?.map((e) => Event.fromJson(e)) ?? [],
        ),
      );
}
