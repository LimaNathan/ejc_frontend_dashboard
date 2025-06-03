import 'package:ejc_frontend_dashboard/app/domains/entities/team_entity.dart';

class TeamModel extends TeamsEntity {
  TeamModel({
    required super.name,
    required super.uuid,
  });

  factory TeamModel.fromEntity(TeamsEntity entity) => TeamModel(
        name: entity.name,
        uuid: entity.uuid,
      );

  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
        name: json['name'] as String,
        uuid: json['id'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'uuid': uuid,
      };
}
