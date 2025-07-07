import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/team_composition/team_composition_viewmodel.dart';
import 'package:ejc_frontend_dashboard/app/views/team_composition/components/add_new_user_on_team_card.dart';
import 'package:ejc_frontend_dashboard/app/views/team_composition/components/team_user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class TeamCompositionView extends StatefulWidget {
  const TeamCompositionView({
    required this.team,
    super.key,
  });
  final TeamModel? team;

  @override
  State<TeamCompositionView> createState() => _TeamCompositionViewState();
}

class _TeamCompositionViewState extends State<TeamCompositionView> {
  late final TeamCompositionViewmodel teamCompositionViewmodel;
  List<DetailedTeamComposition>? composition;

  @override
  void initState() {
    super.initState();

    teamCompositionViewmodel = context.read<TeamCompositionViewmodel>()
      ..onFindTeamCompositionById.addListener(listener);

    teamCompositionViewmodel.onFindTeamCompositionById
        .execute(widget.team?.uuid ?? '');

    teamCompositionViewmodel.onRemoveUserTeamComposition
        .addListener(_onRemoveListener);
  }

  void listener() {
    teamCompositionViewmodel //
        .onFindTeamCompositionById
        .value
        .when(
      data: (data) {
        setState(() {
          composition = data;
        });
      },
      orElse: () {},
    );
  }

  void _onRemoveListener() {
    final result = teamCompositionViewmodel.onRemoveUserTeamComposition.value;

    if (result.isSuccess) {
      // Recarrega a composição da equipe após remover um membro
      teamCompositionViewmodel.onFindTeamCompositionById
          .execute(widget.team?.uuid ?? '');
    }
  }

  @override
  void dispose() {
    super.dispose();
    teamCompositionViewmodel
      ..onFindTeamCompositionById.removeListener(listener)
      ..onRemoveUserTeamComposition.removeListener(_onRemoveListener);
  }

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
        title: Text(
          widget.team?.name ?? '',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: ListenableBuilder(
        listenable: teamCompositionViewmodel.onFindTeamCompositionById,
        builder: (context, snapshot) {
          return teamCompositionViewmodel //
              .onFindTeamCompositionById
              .value
              .when(
            running: () => const Center(
              child: CircularProgressIndicator(),
            ),
            data: (value) {
              if (value.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.groups_rounded,
                        size: 48,
                        color: colorScheme.onSurface,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum membro na equipe',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      AddNewUserOnTeamCard(
                        team: widget.team,
                        composition: composition,
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.all(size.width * .02),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: value.length + 1,
                  itemBuilder: (context, index) {
                    if (index == value.length) {
                      return AddNewUserOnTeamCard(
                        team: widget.team,
                        composition: composition,
                      );
                    }
                    return TeamUserCard(element: value[index]);
                  },
                ),
              );
            },
            orElse: () => Center(
              child: AddNewUserOnTeamCard(
                team: widget.team,
                composition: composition,
              ),
            ),
          );
        },
      ),
    );
  }
}
