import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class NoDataComponent extends StatelessWidget {
  const NoDataComponent({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        children: [
          SizedBox(height: size.height * .2),
          Icon(
            HugeIcons.strokeRoundedDatabaseImport,
            size: size.height * .045,
            color: colorScheme //
                .onSurface
                .withValues(alpha: 0.6),
          ),
          SizedBox(height: size.height * .015),
          const Text('Não há pessoas cadastradas'),
          SizedBox(height: size.height * .2),
        ],
      ),
    );
  }
}
