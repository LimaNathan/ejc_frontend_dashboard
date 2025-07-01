import 'dart:convert';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/viewmodels.dart';
import 'package:ejc_frontend_dashboard/app/views/team_composition/components/remove_from_team_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TeamUserCard extends StatefulWidget {
  const TeamUserCard({required this.element, super.key});

  final DetailedTeamComposition element;

  @override
  State<TeamUserCard> createState() => _TeamUserCardState();
}

class _TeamUserCardState extends State<TeamUserCard> {
  late final TeamCompositionViewmodel teamCompositionViewmodel;

  @override
  void initState() {
    super.initState();

    teamCompositionViewmodel = context.read<TeamCompositionViewmodel>();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final image = Image.memory(
      base64Decode(widget.element.foto.split(',').last),
      height: size.height * .15,
      width: size.width * .25,
      fit: BoxFit.cover,
    );
    //
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ShadCard(
          padding: EdgeInsets.only(bottom: size.height * .025),
          child: Column(
            children: [
              InkWell(
                onTap: () => showImageViewer(context, image.image),
                child: image,
              ),
              Row(
                spacing: size.width * .0025,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.element.name),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.element.role?.title ?? '',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              ...widget.element.telefones.map(Text.new),
            ],
          ),
        ),
        Positioned(
          top: -10,
          right: -10,
          child: IconButton.filled(
            color: colorScheme.error,
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) =>
                    RemoveFromTeamDialog(person: widget.element),
              );
            },
            icon: Icon(
              HugeIcons.strokeRoundedDelete01,
              size: 14,
              color: colorScheme.onError,
            ),
          ),
        ),
      ],
    );
  }
}
