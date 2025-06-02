import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:flutter/material.dart';

class WasWorkedCard extends StatelessWidget {
  const WasWorkedCard({
    required this.person,
    super.key,
  });

  final PersonModel person;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return person.teams != null && person.teams!.isEmpty
        ? Text(
            'Não serviu em nenhum encontro',
            style: textTheme.bodyMedium,
          )
        : Card(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.02,
                vertical: size.height * 0.01,
              ),
              width: size.width > 800 ? size.width * .3 : size.width * .25,
              height: size.height * .25,
              child: ListView.builder(
                itemCount: person.teams!.length,
                itemBuilder: (context, index) {
                  final teams = person
                      .teams![ index];

                  final teamEJC = size.width < 500
                      ? '${teams.encontro}º EJC:'
                          ' ${teams.team ?? 'Não serviu'}'
                      : '${teams.encontro}º:'
                          ' ${teams.team ?? 'Não serviu'}';

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * .15,
                        child: Text(
                          teamEJC,
                          style: textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (teams.isCoordinator)
                        Visibility(
                          visible: size.width > 1080,
                          replacement: Tooltip(
                            message: 'Coordenador(a)',
                            textStyle: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSecondaryFixed,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryFixed,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryFixedDim,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryFixed,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Coordenador(a)',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSecondaryFixed,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          );
  }
}
