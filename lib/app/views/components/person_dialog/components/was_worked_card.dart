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
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.02,
          vertical: size.height * 0.01,
        ),
        width: size.width > 800 ? size.width * 0.4 : size.width * 0.25,
        height: size.height * 0.15,
        child: ListView.builder(
          itemCount: person.teams.length,
          itemBuilder: (context, index) {
            final teams = person.teams[index];
            final teamEJC = '${teams.encontro}º EJC:'
                ' ${teams.team ?? 'Não informado'}';
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  teamEJC,
                  style: textTheme.bodyLarge,
                ),
                if (teams.isCoordinator)
                  Visibility(
                    visible: size.width > 800,
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
