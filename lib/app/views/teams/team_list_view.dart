import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:ejc_frontend_dashboard/app/utils/images/app_images.dart';
import 'package:ejc_frontend_dashboard/app/utils/routes/constants/constant_routes.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/viewmodels.dart';
import 'package:ejc_frontend_dashboard/app/views/components/base/base_view_background.dart';
import 'package:ejc_frontend_dashboard/app/views/teams/components/teams_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TeamListView extends StatefulWidget {
  const TeamListView({super.key});

  @override
  State<TeamListView> createState() => _TeamListViewState();
}

class _TeamListViewState extends State<TeamListView> {
  late final TeamCompositionViewmodel teamViewmodel;

  @override
  void initState() {
    super.initState();

    teamViewmodel = context.read<TeamCompositionViewmodel>()
      ..onFetchTeamsCommand.execute()
      ..onFindTeamCompositionById.addListener(fetchByIDListenter);

    teamViewmodel.onFetchAllCompositionCommand
      ..execute()
      ..addListener(fetchAllCompositionsListener);
  }

  void fetchByIDListenter() {
    final result = teamViewmodel.onFindTeamCompositionById.value;

    final isLoading = result.isRunning;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLoading) {
        ShadToaster.of(context).show(
          const ShadToast(
            title: Text('Aguarde'),
            description: Text('Buscando composição da equipe...'),
          ),
        );
      } else {
        result.when(
          data: (data) {
            ShadToaster.of(context).show(
              const ShadToast(
                title: Text('Sucesso!'),
                description: Text('Composição da equipe encontrada.'),
              ),
            );

            if (GoRouter.of(context).state?.path !=
                ConstantRoutes.teamCompositionView) {
              context.pushNamed(
                ConstantRoutes.teamCompositionView,
                extra: teamViewmodel.onFetchTeamsCommand
                    .getCachedSuccess()
                    ?.firstWhere((test) => test.uuid == data.first.teamId),
              );
            }
          },
          orElse: () {},
          failure: (exception) {
            ShadToaster.of(context).show(
              ShadToast.destructive(
                title: const Text('Ops, ocorreu um erro'),
                description: Text(exception.toString()),
              ),
            );
          },
        );
      }
    });
  }

  void fetchAllCompositionsListener() {
    if (teamViewmodel.onFetchAllCompositionCommand.value.isFailure) {
      ShadToaster.of(context).show(
        ShadToast.destructive(
          title: const Text('Ops, ocorreu um erro'),
          description: Text(
            teamViewmodel.onFetchAllCompositionCommand
                .getCachedFailure()
                .toString(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();

    teamViewmodel
      ..onFindTeamCompositionById.removeListener(fetchByIDListenter)
      ..onFetchAllCompositionCommand
          .removeListener(fetchAllCompositionsListener);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BaseViewBackground(
      child: ListenableBuilder(
        listenable: teamViewmodel.onFetchAllCompositionCommand,
        builder: (context, child) {
          return teamViewmodel.onFetchAllCompositionCommand.value.when(
            data: (data) {
              if (data.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NoTeamsComponent(),
                      AddTeamCard(
                        compositions: [],
                      ),
                    ],
                  ),
                );
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  // Calcula a margem lateral baseada no tamanho da tela
                  final horizontalMargin = size.width <= 1366
                      ? size.width * .1 // 10% para telas menores
                      : size.width <= 1920
                          ? size.width * .2 // 20% para telas médias
                          : size.width * .25; // 25% para telas grandes

                  // Calcula o número de colunas baseado no espaço disponível
                  final availableWidth = size.width - (horizontalMargin * 2);
                  const minCardWidth = 160; // Largura mínima do card

                  final crossAxisCount =
                      (availableWidth / minCardWidth).floor();

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalMargin,
                      vertical: size.height * .02,
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount.clamp(2, 4),
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: data.length + 1,
                      itemBuilder: (context, index) {
                        if (index == data.length) {
                          return AddTeamCard(compositions: data);
                        }
                        final team = data[index];
                        final teamModel = teamViewmodel.onFetchTeamsCommand
                            .getCachedSuccess();

                        return ListenableBuilder(
                          listenable: teamViewmodel.onFetchTeamsCommand,
                          builder: (context, child) {
                            final teamName = teamModel
                                ?.firstWhere((test) => test.uuid == team.teamId)
                                .name;
                            return InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              onTap: () {
                                teamViewmodel.onFindTeamCompositionById
                                    .execute(team.teamId);
                              },
                              child: ShadCard(
                                clipBehavior: Clip.none,
                                padding: EdgeInsets.zero,
                                radius: BorderRadius.circular(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: SvgPicture.asset(
                                        AppImages.getTeamImage(teamName),
                                        height: 64,
                                        width: 64,
                                        placeholderBuilder: (context) =>
                                            const SizedBox(
                                          height: 64,
                                          width: 64,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          debugPrint(
                                            'Erro ao carregar SVG: $error\n$stackTrace',
                                          );
                                          final colorScheme =
                                              Theme.of(context).colorScheme;
                                          return Container(
                                            height: 64,
                                            width: 64,
                                            decoration: BoxDecoration(
                                              color:
                                                  colorScheme.primaryContainer,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.groups_rounded,
                                              size: 32,
                                              color: colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      teamName ?? '--',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
            orElse: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class NoTeamsComponent extends StatelessWidget {
  const NoTeamsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text(
            'Nenhuma equipe montada. \n'
            'Adicione uma nova abaixo',
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class AddTeamCard extends StatefulWidget {
  const AddTeamCard({
    required this.compositions,
    super.key,
  });

  final List<TeamComposition> compositions;

  @override
  State<AddTeamCard> createState() => _AddTeamCardState();
}

class _AddTeamCardState extends State<AddTeamCard> {
  TeamModel? team;
  @override
  Widget build(BuildContext context) {
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
            builder: (context) => TeamsMenu(compositions: widget.compositions),
          );
        },
        child: SizedBox(
          child: Column(
            children: [
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
                    'Adicionar nova equipe',
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

class MenuEntry {
  const MenuEntry({
    required this.label,
    this.shortcut,
    this.onPressed,
    this.menuChildren,
  }) : assert(
          menuChildren == null || onPressed == null,
          'onPressed is ignored if menuChildren are provided',
        );
  final String label;

  final MenuSerializableShortcut? shortcut;
  final VoidCallback? onPressed;
  final List<MenuEntry>? menuChildren;

  static List<Widget> build(List<MenuEntry> selections) {
    Widget buildSelection(MenuEntry selection) {
      if (selection.menuChildren != null) {
        return SubmenuButton(
          menuChildren: MenuEntry.build(selection.menuChildren!),
          child: Text(selection.label),
        );
      }
      return MenuItemButton(
        shortcut: selection.shortcut,
        onPressed: selection.onPressed,
        child: Text(selection.label),
      );
    }

    return selections.map<Widget>(buildSelection).toList();
  }

  static Map<MenuSerializableShortcut, Intent> shortcuts(
    List<MenuEntry> selections,
  ) {
    final result = <MenuSerializableShortcut, Intent>{};
    for (final selection in selections) {
      if (selection.menuChildren != null) {
        result.addAll(MenuEntry.shortcuts(selection.menuChildren!));
      } else {
        if (selection.shortcut != null && selection.onPressed != null) {
          result[selection.shortcut!] =
              VoidCallbackIntent(selection.onPressed!);
        }
      }
    }
    return result;
  }
}
