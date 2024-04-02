class MatchStats {
  final int teamId;
  final String teamName;
  final String teamLogo;
  final Map<String, dynamic> statistics;

  MatchStats({
    required this.teamId,
    required this.teamName,
    required this.teamLogo,
    required this.statistics,
  });

  factory MatchStats.fromJson(Map<String, dynamic> json) {
    final teamData = json['team'];
    final statsData = json['statistics'];

    Map<String, dynamic> statsMap = {};
    for (var stat in statsData) {
      statsMap[stat['type']] = stat['value'];
    }

    return MatchStats(
      teamId: teamData['id'],
      teamName: teamData['name'],
      teamLogo: teamData['logo'],
      statistics: statsMap,
    );
  }
}