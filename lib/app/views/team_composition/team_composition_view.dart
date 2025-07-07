import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/team_composition/team_composition_viewmodel.dart';
import 'package:ejc_frontend_dashboard/app/views/team_composition/components/add_new_user_on_team_card.dart';
import 'package:ejc_frontend_dashboard/app/views/team_composition/components/team_user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
  final TextEditingController _searchController = TextEditingController();
  List<DetailedTeamComposition>? _filteredComposition;

  @override
  void initState() {
    super.initState();

    teamCompositionViewmodel = context.read<TeamCompositionViewmodel>()
      ..onFindTeamCompositionById.addListener(listener);

    teamCompositionViewmodel.onFindTeamCompositionById
        .execute(widget.team?.uuid ?? '');

    teamCompositionViewmodel.onRemoveUserTeamComposition
        .addListener(_onRemoveListener);

    _searchController.addListener(_filterComposition);
  }

  void _filterComposition() {
    final searchTerm = _searchController.text.toLowerCase();
    setState(() {
      if (searchTerm.isEmpty) {
        _filteredComposition = composition;
      } else {
        _filteredComposition = composition?.where((member) {
          final userName = member.name.toLowerCase();
          return userName.contains(searchTerm);
        }).toList();
      }
    });
  }

  void listener() {
    teamCompositionViewmodel //
        .onFindTeamCompositionById
        .value
        .when(
      data: (data) {
        setState(() {
          composition = data;
          _filteredComposition = data;
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
    _searchController.dispose();
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * .1,
              vertical: size.height * .02,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ShadInput(
                    controller: _searchController,
                    placeholder: const Text('Buscar membro por nome...'),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Total: ${_filteredComposition?.length ?? 0} membros',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListenableBuilder(
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
                    if (_filteredComposition?.isEmpty ?? true) {
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

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // Calcula a margem lateral baseada no tamanho da tela
                        final horizontalMargin = size.width <= 1366
                            ? size.width * .05 // 5% para telas menores
                            : size.width <= 1920
                                ? size.width * .1 // 10% para telas médias
                                : size.width * .15; // 15% para telas grandes

                        // Calcula o número de colunas baseado no espaço disponível
                        final availableWidth =
                            size.width - (horizontalMargin * 2);
                        const minCardWidth = 300.0; // Largura mínima do card
                        final crossAxisCount =
                            (availableWidth / minCardWidth).floor();

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalMargin,
                            vertical: size.height * .02,
                          ),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount.clamp(2, 4),
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: (_filteredComposition?.length ?? 0) + 1,
                            itemBuilder: (context, index) {
                              if (index ==
                                  (_filteredComposition?.length ?? 0)) {
                                return AddNewUserOnTeamCard(
                                  team: widget.team,
                                  composition: composition,
                                );
                              }
                              return TeamUserCard(
                                element: _filteredComposition![index],
                              );
                            },
                          ),
                        );
                      },
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
          ),
        ],
      ),
    );
  }
}
