import 'dart:convert';

import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/views/components/no_data/no_data_component.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_tile/list_tile_card.dart';
import 'package:flutter/material.dart';

class ListViewBuilderPersonTile extends StatelessWidget {
  const ListViewBuilderPersonTile({
    required this.persons,
    super.key,
  });

  final List<PersonModel>? persons;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    return persons != null && persons!.isNotEmpty
        ? Card(
            color: colorScheme.surfaceContainerHigh.withAlpha(255),
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: persons != null ? persons!.length : 0,
              itemBuilder: (context, index) {
                final person = persons![index];
                try {
                  base64Decode(person.photo!);
                } catch (e) {
                  person.photo = null;
                }
                final circle = person.circle.isEmpty
                    ? size.width < 600
                        ? '--'
                        : 'Círculo não informado'
                    : size.width < 600
                        ? '${person.circle}'
                            ' ${person.ejcNumber}'
                        : 'Círculo ${person.circle}'
                            ' ${person.ejcNumber}';

                return ListTilePersonCard(
                  person: person,
                  circle: circle,
                );
              },
            ),
          )
        : const NoDataComponent();
  }
}
