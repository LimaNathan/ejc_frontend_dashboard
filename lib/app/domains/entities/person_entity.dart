class PersonEntity {
  PersonEntity({
    required this.name,
    required this.aniversario,
    required this.circle,
    required this.ejcNumber,
    required this.skills,
    required this.teams,
    required this.phones,
    this.photo,
  });

  String name;
  String? photo;
  String circle;
  DateTime aniversario;
  String ejcNumber;
  List<String> skills;
  List<TeamParticipationEntity> teams;
  List<String> phones;
}

class TeamParticipationEntity {
  TeamParticipationEntity({
    required this.encontro,
    required this.isCoordinator,
    this.team,
  });


  final String encontro;
  final String? team;
  final bool isCoordinator;
}
