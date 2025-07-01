import 'package:ejc_frontend_dashboard/app/domains/dtos/team/enum/team_role.dart';

class TeamComposition {
  TeamComposition({
    required this.teamId,
    required this.userId,
    required this.role,
  });

  factory TeamComposition.fromJson(Map<String, Object?> json) =>
      TeamComposition(
        teamId: json['team_id']! as String,
        userId: json['user_id']! as String,
        role: TeamRoleExtension.fromString(json['role']! as String),
      );

  Map<String, dynamic> toJson() => {
        'team_id': teamId,
        'user_id': userId,
        'role': role.value,
      };

  final String teamId;

  final String userId;
  final TeamRole role;
}
