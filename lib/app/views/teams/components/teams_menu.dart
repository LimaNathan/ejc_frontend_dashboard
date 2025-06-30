// ignore_for_file: must_be_immutable

import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:ejc_frontend_dashboard/app/utils/routes/constants/constant_routes.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/team_composition/team_composition_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class TeamsMenu extends StatefulWidget {
  TeamsMenu({
    required this.compositions,
    this.team,
    super.key,
  });
  TeamModel? team;

  final List<TeamComposition> compositions;

  @override
  State<TeamsMenu> createState() => _TeamsMenuState();
}

class _TeamsMenuState extends State<TeamsMenu> {
  late final TeamCompositionViewmodel teamCompositionViewmodel;

  @override
  void initState() {
    super.initState();
    teamCompositionViewmodel = context.read<TeamCompositionViewmodel>()
      ..onFetchTeamsCommand.execute();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.01,
          horizontal: size.width * 0.03,
        ),
        width: size.width * 0.35,
        height: size.height * 0.35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Adicionar nova equipe',
                  style: textTheme.headlineMedium,
                ),
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.05),
            ListenableBuilder(
                listenable: teamCompositionViewmodel.onFetchTeamsCommand,
                builder: (context, _) {
                  return teamCompositionViewmodel //
                      .onFetchTeamsCommand
                      .value
                      .when(
                    data: (data) {
                      final itens = data.map((toElement) {
                        return PopupMenuItem<TeamModel>(
                          value: toElement,
                          onTap: () => setState(() {
                            widget.team = toElement;
                          }),
                          child: Text(toElement.name),
                        );
                      }).toList();

                      return PopupMenuButton<TeamModel>(
                        offset: const Offset(0, 40),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          width: size.width * 0.25,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colorScheme.outline),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.team?.name ?? 'Equipes...',
                                style: textTheme.bodyMedium,
                              ),
                              const Spacer(),
                              Icon(
                                HugeIcons.strokeRoundedArrowDown01,
                                size: 20,
                                color: colorScheme.onSurface,
                              ),
                            ],
                          ),
                        ),
                        itemBuilder: (context) => itens,
                      );
                    },
                    orElse: Container.new,
                  );
                }),
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.12,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.12,
                  child: FilledButton(
                    onPressed: () {
                      context.pop();
                      if (widget.compositions.isEmpty) {
                        context.pushNamed(
                          ConstantRoutes.teamCompositionView,
                          extra: widget.team,
                        );
                      }
                    },
                    child: const Text('Criar equipe'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
