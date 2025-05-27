import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class PersonDialog extends StatelessWidget {
  const PersonDialog({super.key, required this.person});
  final PersonModel person;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.035,
          horizontal: size.width * 0.04,
        ),
        width: size.width * 0.75,
        height: size.height * 0.75,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  person.name,
                  style: textTheme.headlineMedium,
                ),
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
