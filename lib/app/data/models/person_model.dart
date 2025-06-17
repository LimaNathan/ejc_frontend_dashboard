// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:ejc_frontend_dashboard/app/domains/entities/person_entity.dart';

class PersonModel extends PersonEntity {
  PersonModel({
    required super.name,
    required super.circle,
    required super.ejcNumber,
    required super.skills,
    required super.phones,
    required super.aniversario,
    required super.uuid,
    super.teams,
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
        uuid: entity.uuid,
      );

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    final personModel = PersonModel(
      uuid: json['id'] as String,
      name: json['nome'] as String,
      photo: (json['foto'] as String).split(',').last,
      circle: json['circulo'] as String,
      ejcNumber: json['ejc_fez'] as String,
      aniversario: DateTime.parse(json['aniversario'] as String),
      skills: List<String>.from(
        json['aptidoes'] is String
            ? jsonDecode(json['aptidoes'] as String) as List
            : json['aptidoes'] as List,
      ),
      teams: (json['user_teams'] == null)
          ? null
          : List<TeamParticipationModel>.from(
              (json['user_teams'] as Iterable).map(
                (x) => TeamParticipationModel(
                  encontro: (x['encontro'] as int).toString(),
                  team:
                      x['teams'] != null ? x['teams']['name'] as String : null,
                  isCoordinator: x['is_coordinator'] as bool,
                ),
              ),
            ),
      phones: List<String>.from(json['telefones'] as Iterable<dynamic>),
    );

    return personModel //
      ..teams //
          ?.sort(
        (a, b) => a.encontro //
            .compareTo(b.encontro),
      );
  }

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
    required super.isCoordinator,
    super.team,
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
