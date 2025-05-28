import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:flutter/material.dart';

class SkillsCard extends StatelessWidget {
  const SkillsCard({
    required this.person,
    super.key,
  });

  final PersonModel person;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.02,
          vertical: size.height * 0.01,
        ),
        width: size.width > 800 ? size.width * 0.3 : size.width * 0.25,
        height: size.height * .25,
        child: ListView.builder(
          itemCount: person.skills.length,
          itemBuilder: (context, index) {
            final skill = person.skills[index];

            return Text(skill, style: textTheme.bodyLarge);
          },
        ),
      ),
    );
  }
}
