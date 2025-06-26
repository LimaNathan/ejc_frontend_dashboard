import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/show_custom_snackbar.dart';
import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/snackbar_type.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/team_composition/fetch_teams/fetch_teams_bloc.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/viewmodels.dart';
import 'package:ejc_frontend_dashboard/app/views/components/base/base_view_background.dart';
import 'package:ejc_frontend_dashboard/app/views/teams/components/teams_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
    blocCompositions = TeamCompositionViewmodelBloc(context.read())
      ..add(OnFetchAllCompositions());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => blocCompositions,
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
                  AddTeamCard(compositions: state.compositions),
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
  const NoTeamsComponent({
    super.key,
  });

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
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    return ShadCard(
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (context) => BlocProvider(
              create: (context) => FetchTeamBloc //
                  (context.read())
                ..add(OnFetchAllTeams()),
              child: BlocBuilder<FetchTeamBloc, FetchTeamState>(
                builder: (context, state) {
                  return TeamsMenu(
                    team: team,
                    state: state,
                    compositions: widget.compositions,
                  );
                },
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
