import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/enum/team_role.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:ejc_frontend_dashboard/app/utils/extensions/json_nested_extension.dart';

class DetailedTeamComposition extends TeamComposition {
  DetailedTeamComposition({
    required super.teamId,
    required super.userId,
    required super.role,
    required this.name,
    required this.foto,
    required this.telefones,
  });
  factory DetailedTeamComposition.fromJson(Map<String, dynamic> json) =>
      DetailedTeamComposition(
        teamId: json['team_id'] as String,
        userId: json['user_id'] as String,
        role: TeamRoleExtension.fromString(json['role'] as String),
        name: json.nestedField<String>('users', 'nome'),
        foto: json.nestedField<String>('users', 'foto'),
        telefones: List<String>.from(
          json //
              .nestedField<List<dynamic>>('users', 'telefones'),
        ),
      );

  factory DetailedTeamComposition.fromPersonAndTeam(
    PersonModel person,
    TeamModel team,
    TeamRole role,
  ) {
    return DetailedTeamComposition(
      teamId: team.uuid!,
      userId: person.uuid,
      role: role,
      name: person.name,
      foto: person.photo!,
      telefones: person.phones,
    );
  }
  final String name;
  final String foto;
  final List<String> telefones;
}
