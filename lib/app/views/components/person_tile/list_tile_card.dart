import 'dart:convert';

import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_dialog/person_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ListTilePersonCard extends StatelessWidget {
  const ListTilePersonCard({
    required this.person,
    required this.circle,
    super.key,
  });

  final PersonModel person;

  final String circle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (context) => PersonDialog(
            person: person,
          ),
        );
      },
      child: Card(
        semanticContainer: false,
        shadowColor: colorScheme.outline.withValues(alpha: 200),
        elevation: 1,
        color: colorScheme.surfaceContainerLowest.withValues(
          alpha: 50,
        ),
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
                      child: person.photo != null
                          ? ClipOval(
                              child: Image.memory(
                                base64Decode(
                                  person.photo!,
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
                      person.name,
                      style: textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: size.width < 600 ? 2 : 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${person.ejcNumber}º EJC',
                      style: textTheme.bodySmall,
                    ),
                    SizedBox(width: size.width * .01),
                    SizedBox(
                      width: size.width * .1,
                      child: Text(
                        circle,
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
