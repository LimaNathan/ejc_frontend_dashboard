import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:ejc_frontend_dashboard/app/views/home_navigation/components/text_field_search_people.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AddNewUserOnTeamCard extends StatefulWidget {
  const AddNewUserOnTeamCard({
    required this.team,
    required this.composition,
    super.key,
  });
  final TeamModel? team;
  final List<DetailedTeamComposition>? composition;

  @override
  State<AddNewUserOnTeamCard> createState() => _AddNewUserOnTeamCardState();
}

class _AddNewUserOnTeamCardState extends State<AddNewUserOnTeamCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    return ShadCard(
      clipBehavior: Clip.none,
      padding: EdgeInsets.zero,
      radius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                  height: size.height * .45,
                  width: size.width * .45,
                  padding: EdgeInsets.all(size.width * .025),
                  child: TextFieldSearchPeople(
                    team: widget.team,
                    isAddingToTeam: true,
                    composition: widget.composition,
                  ),
                ),
              );
            },
          );
        },
        child: SizedBox(
          height: size.height * 0.2,
          width: size.width * 0.25,
          child: Column(
            children: [
              if (widget.composition != null)
                ...widget.composition!.map(
                  (e) {
                    return Text(e.name);
                  },
                ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12),
                    ),
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedAdd02,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Adicionar novo participante.',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
