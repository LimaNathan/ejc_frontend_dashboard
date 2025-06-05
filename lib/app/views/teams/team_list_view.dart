import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/show_custom_snackbar.dart';
import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/snackbar_type.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/team_composition/fetch_teams/fetch_teams_bloc.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/viewmodels.dart';
import 'package:ejc_frontend_dashboard/app/views/components/base/base_view_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

class TeamListView extends StatefulWidget {
  const TeamListView({super.key});

  @override
  State<TeamListView> createState() => _TeamListViewState();
}

class _TeamListViewState extends State<TeamListView> {
  late FetchTeamBloc blocTeams;
  late TeamCompositionViewmodelBloc blocCompositions;

  @override
  void initState() {
    super.initState();
    blocTeams = FetchTeamBloc(context.read())..add(OnFetchAllTeams());
    blocCompositions = TeamCompositionViewmodelBloc(context.read())
      ..add(OnFetchAllCompositions());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => blocTeams),
        BlocProvider(create: (context) => blocCompositions),
      ],
      child: BlocBuilder<TeamCompositionViewmodelBloc,
          TeamCompositionViewmodelState>(
        builder: (context, state) {
          if (state is TeamCompositionViewmodelLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TeamCompositionError) {
            showCustomSnackbar(
              context,
              message: state.message,
              type: SnackbarType.error,
            );
          }

          if (state is LoadedAllCompositions) {
            return BaseViewBackground(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.compositions.isEmpty) const NoTeamsComponent(),
                ],
              ),
            );
          }
          return BaseViewBackground(
            child: Container(),
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
    final size = MediaQuery.of(context).size;

    return Center(
      child: Column(
        children: [
          const Text(
            'Nenhuma equipe montada. '
            '\nAdicione uma nova abaixo',
          ),
          SizedBox(height: size.height * 0.05),
          const AddTeamCard(),
        ],
      ),
    );
  }
}

class AddTeamCard extends StatelessWidget {
  const AddTeamCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final blocTeam = context.read<FetchTeamBloc>();

    final teams = blocTeam.state is FetchTeamSuccess
        ? (blocTeam.state as FetchTeamSuccess).teams
        : <TeamModel>[];
    return Card(
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.03,
                  horizontal: size.width * 0.035,
                ),
                width: size.width * 0.35,
                height: size.height * 0.25,
                child: Column(
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
                    PopupMenuButton<TeamModel>(
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
                              'Equipes...',
                              style: textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            Icon(
                              HugeIcons.strokeRoundedArrowDown01,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context) {
                        return [
                          ...teams.map((e) {
                            return PopupMenuItem<TeamModel>(
                              value: e,
                              child: Text(e.name),
                            );
                          }),
                        ];
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: SizedBox(
          height: size.height * 0.2,
          width: size.width * 0.25,
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
