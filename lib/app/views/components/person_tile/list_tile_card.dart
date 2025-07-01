import 'dart:convert';

import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_dialog/person_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ListTilePersonCard extends StatefulWidget {
  ListTilePersonCard({
    required this.person,
    this.circle = '--',
    this.resumed = false,
    this.isAddingToTeam,
    this.composition,
    this.onPressed,
    this.team,
    super.key,
  });

  final PersonModel person;
  final bool resumed;
  final TeamModel? team;
  final String circle;
  final void Function()? onPressed;
  List<DetailedTeamComposition>? composition;

  final bool? isAddingToTeam;

  @override
  State<ListTilePersonCard> createState() => _ListTilePersonCardState();
}

class _ListTilePersonCardState extends State<ListTilePersonCard> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        if (widget.onPressed != null) widget.onPressed!.call();

        showDialog<void>(
          context: context,
          builder: (context) => PersonDialog(
            person: widget.person,
            isAddingToTeam: widget.isAddingToTeam,
            composition: widget.composition,
            team: widget.team,
          ),
        );
      },
      child: ShadCard(
        // semanticContainer: false,
        // shadowColor: colorScheme.outline.withValues(alpha: 200),
        // elevation: 1,
        backgroundColor: colorScheme //
            .surfaceContainerLowest
            .withValues(alpha: 80),

        leading: CircleAvatar(
          child: widget.person.photo != null
              ? ClipOval(
                  child: Image.memory(
                    base64Decode(
                      widget.person.photo!,
                    ),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                )
              : const Icon(
                  HugeIcons.strokeRoundedUserList,
                ),
        ),
        title: Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: size.width * .025),
            child: Text(
              'Nome: ',
              style: Theme.of(context) //
                  .textTheme
                  .titleSmall,
            ),
          ),
        ),

        trailing: Row(
          mainAxisAlignment: !widget.resumed
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
          children: [
            if (widget.person.equipeAtual != null &&
                widget.person.equipeAtual!.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * .0055),
                margin: EdgeInsets.only(right: size.width * .0055),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.person.equipeAtual ?? '',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            Text(
              '${widget.person.ejcNumber}º EJC',
              style: textTheme.bodySmall,
            ),
            if (!widget.resumed) SizedBox(width: size.width * .01),
            if (!widget.resumed)
              SizedBox(
                width: size.width * .06,
                child: Text(
                  widget.circle,
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(left: size.width * .025),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.person.name,
              style: textTheme.labelLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        /*  child: Container(
          margin: EdgeInsets.symmetric(
            vertical: size.height * 0.01,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.015,
            vertical: size.height * 0.015,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: Row(
                  children: [
                    CircleAvatar(
                      child: widget.person.photo != null
                          ? ClipOval(
                              child: Image.memory(
                                base64Decode(
                                  widget.person.photo!,
                                ),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            )
                          : const Icon(
                              HugeIcons.strokeRoundedUserList,
                            ),
                    ),
                    SizedBox(width: size.width * .02),
                    Flexible(
                      child: Text(
                        widget.person.name,
                        style: textTheme.labelLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: size.width < 600 ? 2 : 1,
                child: Row(
                  mainAxisAlignment: !widget.resumed
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    Text(
                      '${widget.person.ejcNumber}º EJC',
                      style: textTheme.bodySmall,
                    ),
                    if (!widget.resumed) SizedBox(width: size.width * .01),
                    if (!widget.resumed)
                      SizedBox(
                        width: size.width * .06,
                        child: Text(
                          widget.circle,
                          style: textTheme.bodySmall,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ), */
      ),
    );
  }
}
