// ignore_for_file: avoid_dynamic_calls

import 'package:ejc_frontend_dashboard/app/domains/entities/person_entity.dart';

class PersonModel extends PersonEntity {
  PersonModel({
    required super.name,
    required super.circle,
    required super.ejcNumber,
    required super.skills,
    required super.teams,
    required super.phones,
    required super.aniversario,
    super.photo,
  });

  factory PersonModel.fromEntity(PersonEntity entity) => PersonModel(
        name: entity.name,
        photo: entity.photo,
        circle: entity.circle,
        ejcNumber: entity.ejcNumber,
        skills: entity.skills,
        teams: entity.teams,
        phones: entity.phones,
        aniversario: entity.aniversario,
      );

  factory PersonModel.fromJson(Map<String, dynamic> json) => PersonModel(
        name: json['nome'] as String,
        photo: json['foto'] as String,
        circle: json['circulo'] as String,
        ejcNumber: json['ejc_fez'] as String,
        aniversario: json['aniversario'] as DateTime,
        skills: List<String>.from(json['aptidoes'] as Iterable<dynamic>),
        teams: List<TeamParticipationModel>.from(
          (json['equipes'] as Iterable).map(
            (x) => TeamParticipationModel(
              encontro: x['encontro'] as String,
              team: x['equipe'] as String,
              isCoordinator: x['is_coordinator'] as bool,
            ),
          ),
        ),
        phones: List<String>.from(json['telefones'] as Iterable<dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'nome': name,
        'foto': photo,
        'circulo': circle,
        'ejc_fez': ejcNumber,
        'aptidoes': skills,
        'aniversario': aniversario.toIso8601String(),
        'telefones': phones,
      };
}

class TeamParticipationModel extends TeamParticipationEntity {
  TeamParticipationModel({
    required super.encontro,
    required super.team,
    required super.isCoordinator,
  });

  factory TeamParticipationModel.fromEntity(TeamParticipationEntity entity) =>
      TeamParticipationModel(
        encontro: entity.encontro,
        team: entity.team,
        isCoordinator: entity.isCoordinator,
      );

  factory TeamParticipationModel.fromJson(Map<String, dynamic> json) =>
      TeamParticipationModel(
        encontro: json['encontro'] as String,
        team: json['equipe'] as String,
        isCoordinator: json['is_coordinator'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'encontro': encontro,
        'equipe': team,
        'is_coordinator': isCoordinator,
      };
}
