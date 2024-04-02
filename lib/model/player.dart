class TopScorer {
  final Player player;
  final List<Statistics> statistics;

  TopScorer({required this.player, required this.statistics});

  factory TopScorer.fromJson(Map<String, dynamic> json) {
    return TopScorer(
      player: Player.fromJson(json['player']),
      statistics: List<Statistics>.from(json['statistics'].map((x) => Statistics.fromJson(x))),
    );
  }
}

class Player {
  final int id;
  final String name;
  final String firstname;
  final String lastname;
  final int age;
  final Birth birth;
  final String nationality;
  final String height;
  final String weight;
  final bool injured;
  final String photo;

  Player({
    required this.id,
    required this.name,
    required this.firstname,
    required this.lastname,
    required this.age,
    required this.birth,
    required this.nationality,
    required this.height,
    required this.weight,
    required this.injured,
    required this.photo,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
  return Player(
    id: json['id'] as int? ?? 0,
    name: json['name'] as String? ?? 'Unknown',
    firstname: json['firstname'] as String? ?? 'Unknown',
    lastname: json['lastname'] as String? ?? 'Unknown',
    age: json['age'] as int? ?? 0,
    birth: json['birth'] != null ? Birth.fromJson(json['birth']) : Birth(date: '', place: '', country: ''),
    nationality: json['nationality'] as String? ?? 'Unknown',
    height: json['height'] as String? ?? 'Unknown',
    weight: json['weight'] as String? ?? 'Unknown',
    injured: json['injured'] as bool? ?? false,
    photo: json['photo'] as String? ?? '',
  );
}
}

class Birth {
  final String date;
  final String place;
  final String country;

  Birth({required this.date, required this.place, required this.country});

  factory Birth.fromJson(Map<String, dynamic> json) {
    return Birth(
      date: json['date'] as String? ?? 'Unknown',
      place: json['place'] as String? ?? 'Unknown',
      country: json['country'] as String? ?? 'Unknown',
    );
  }
}

class Statistics {
  final Team team;
  final League league;
  final Games games;
  final Substitutes substitutes;
  final Shots shots;
  final Goals goals;
  final Passes passes;
  final Tackles tackles;
  final Duels duels;
  final Dribbles dribbles;
  final Fouls fouls;
  final Cards cards;
  final Penalty penalty;

  Statistics({
    required this.team,
    required this.league,
    required this.games,
    required this.substitutes,
    required this.shots,
    required this.goals,
    required this.passes,
    required this.tackles,
    required this.duels,
    required this.dribbles,
    required this.fouls,
    required this.cards,
    required this.penalty,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      team: Team.fromJson(json['team']  ?? {}) ,
      league: League.fromJson(json['league'] ?? {}),
      games: Games.fromJson(json['games']   ?? {}),
      substitutes: Substitutes.fromJson(json['substitutes'] ?? {}),
      shots: Shots.fromJson(json['shots']  ?? {}), 
      goals: Goals.fromJson(json['goals']   ?? {}),
      passes: Passes.fromJson(json['passes']  ?? {}),
      tackles: Tackles.fromJson(json['tackles'] ?? {}),
      duels: Duels.fromJson(json['duels']  ?? {}),
      dribbles: Dribbles.fromJson(json['dribbles']  ?? {}),
      fouls: Fouls.fromJson(json['fouls']  ?? {}),
      cards: Cards.fromJson(json['cards']  ?? {}),
      penalty: Penalty.fromJson(json['penalty']  ?? {}),
    );
  }
}

class Team {
  final int id;
  final String name;
  final String logo;

  Team({required this.id, required this.name, required this.logo});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      logo: json['logo']  ?? 'Unknown',
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

  League({
    required this.id,
    required this.name,
    required this.country,
    required this.logo,
    required this.flag,
    required this.season,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      country: json['country'] ?? 'Unknown',
      logo: json['logo'] ?? 'Unknown',
      flag: json['flag'] ?? 'Unknown',
      season: json['season'] ?? 0,
    );
  }
}

class Games {
  final int appearances;
  final int lineups;
  final int minutes;
  final String position;
  final String rating;
  final bool captain;

  Games({
    required this.appearances,
    required this.lineups,
    required this.minutes,
    required this.position,
    required this.rating,
    required this.captain,
  });

  factory Games.fromJson(Map<String, dynamic> json) {
    return Games(
      appearances: json['appearences'] ?? 0,
      lineups: json['lineups'] ?? 0,
      minutes: json['minutes'] ?? 0,
      position: json['position'] ?? 'Unknown',
      rating: json['rating'] ?? 'Unknown',
      captain: json['captain'] ?? false,
    );
  }
}

class Substitutes {
  final int ins;
  final int outs;
  final int bench;

  Substitutes({required this.ins, required this.outs, required this.bench});

  factory Substitutes.fromJson(Map<String, dynamic> json) {
    return Substitutes(
      ins: json['in'] ?? 0,
      outs: json['out'] ?? 0,
      bench: json['bench'] ?? 0,
    );
  }
}

class Shots {
  final int total;
  final int on;

  Shots({required this.total, required this.on});

  factory Shots.fromJson(Map<String, dynamic> json) {
    return Shots(
      total: json['total'] ?? 0,
      on: json['on'] ?? 0,
    );
  }
}

class Goals {
  final int total;
  final int assists;

  Goals({required this.total, required this.assists});

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      total: json['total'] ?? 0,
      assists: json['assists'] ?? 0,
    );
  }
}

class Passes {
  final int total;
  final int key;
  final int accuracy;

  Passes({required this.total, required this.key, required this.accuracy});

  factory Passes.fromJson(Map<String, dynamic> json) {
    return Passes(
      total: json['total'] ?? 0,
      key: json['key'] ?? 0,
      accuracy: json['accuracy'] ?? 0,
    );
  }
}

class Tackles {
  final int total;
  final int blocks;
  final int interceptions;

  Tackles({required this.total, required this.blocks, required this.interceptions});

  factory Tackles.fromJson(Map<String, dynamic> json) {
    return Tackles(
      total: json['total'] ?? 0,
      blocks: json['blocks'] ?? 0,
      interceptions: json['interceptions'] ?? 0,
    );
  }
}

class Duels {
  final int total;
  final int won;

  Duels({required this.total, required this.won});

  factory Duels.fromJson(Map<String, dynamic> json) {
    return Duels(
      total: json['total'] ?? 0,
      won: json['won'] ?? 0,
    );
  }
}

class Dribbles {
  final int attempts;
  final int success;

  Dribbles({required this.attempts, required this.success});

  factory Dribbles.fromJson(Map<String, dynamic> json) {
    return Dribbles(
      attempts: json['attempts'] ?? 0,
      success: json['success'] ?? 0,
    );
  }
}

class Fouls {
  final int drawn;
  final int committed;

  Fouls({required this.drawn, required this.committed});

  factory Fouls.fromJson(Map<String, dynamic> json) {
    return Fouls(
      drawn: json['drawn'] ?? 0,
      committed: json['committed'] ?? 0,
    );
  }
}

class Cards {
  final int yellow;
  final int red;

  Cards({required this.yellow, required this.red});

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      yellow: json['yellow'] ?? 0,
      red: json['red'] ?? 0,
    );
  }
}

class Penalty {
  final int scored;
  final int missed;

  Penalty({required this.scored, required this.missed});

  factory Penalty.fromJson(Map<String, dynamic> json) {
    return Penalty(
      scored: json['scored'] ?? 0,
      missed: json['missed'] ?? 0,
    );
  }
}
