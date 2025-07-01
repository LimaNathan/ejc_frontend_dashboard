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
  }

  void listener() {
    composition = teamCompositionViewmodel //
        .onFindTeamCompositionById
        .value
        .when(
      data: (data) {
        composition = data;
        return null;
      },
      orElse: () {},
    );
  }

  @override
  void dispose() {
    super.dispose();

    teamCompositionViewmodel.onFindTeamCompositionById.removeListener(listener);
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
        title: Text(widget.team?.name ?? ''),
      ),
      body: ListenableBuilder(
        listenable: teamCompositionViewmodel.onFindTeamCompositionById,
        builder: (context, snapshot) {
          return teamCompositionViewmodel //
              .onFindTeamCompositionById
              .value
              .when(
            running: () => const Center(child: CircularProgressIndicator()),
            data: (value) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  OverflowBar(
                    spacing: size.width * .025,
                    children: teamCompositionViewmodel //
                        .onFindTeamCompositionById
                        .value
                        .when(
                      data: (value) {
                        return value
                            .map((element) => TeamUserCard(element: element))
                            .toList();
                      },
                      orElse: () => <Widget>[],
                    ),
                  ),
                  Center(
                    child: AddNewUserOnTeamCard(
                      team: widget.team,
                      composition: composition,
                    ),
                  ),
                ],
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
