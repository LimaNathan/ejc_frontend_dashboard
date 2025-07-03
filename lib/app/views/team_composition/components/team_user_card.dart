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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final photo = widget.element.foto.split(',').last;
    final imageProvider = MemoryImage(base64Decode(photo));

    return ShadCard(
      clipBehavior: Clip.none,
      padding: EdgeInsets.zero,
      radius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: () => showImageViewer(context, imageProvider),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.element.name,
                          style: textTheme.titleSmall,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.element.role?.title ?? '',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.element.telefones.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.element.telefones.first,
                            style: textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: -8,
              right: -8,
              child: ShadButton.destructive(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => RemoveFromTeamDialog(
                      person: widget.element,
                    ),
                  );
                },
                child: Icon(
                  HugeIcons.strokeRoundedDelete01,
                  size: 14,
                  color: colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
