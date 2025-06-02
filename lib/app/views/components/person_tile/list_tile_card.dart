import 'dart:convert';

import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_dialog/person_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ListTilePersonCard extends StatefulWidget {
  const ListTilePersonCard({
    required this.person,
    this.circle = '--',
    this.resumed = false,
    this.onPressed,
    super.key,
  });

  final PersonModel person;
  final bool resumed;
  final String circle;
  final void Function()? onPressed;

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
          ),
        );
      },
      child: Card(
        semanticContainer: false,
        shadowColor: colorScheme.outline.withValues(alpha: 200),
        elevation: 1,
        color: colorScheme //
            .surfaceContainerLowest
            .withValues(alpha: 80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
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
                    Text(
                      widget.person.name,
                      style: textTheme.labelLarge,
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
        ),
      ),
    );
  }
}
