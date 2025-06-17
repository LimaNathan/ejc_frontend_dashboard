import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:ejc_frontend_dashboard/app/views/home_navigation/components/text_field_search_people.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class TeamCompositionView extends StatefulWidget {
  const TeamCompositionView({
    required this.team,
    super.key,
  });
  final TeamModel team;

  @override
  State<TeamCompositionView> createState() => _TeamCompositionViewState();
}

class _TeamCompositionViewState extends State<TeamCompositionView> {
  List<DetailedTeamComposition>? composition;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * 0.09,
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            HugeIcons.strokeRoundedArrowLeft01,
          ),
          onPressed: context.pop,
        ),
        centerTitle: true,
        title: Text(widget.team.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Card(
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
                            composition: composition,
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
                      if (composition != null)
                        ...composition!.map(
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
