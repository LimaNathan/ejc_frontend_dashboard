import 'package:flutter/material.dart';

class BasicInfoCard extends StatelessWidget {
  const BasicInfoCard({
    required this.title,
    required this.info,
    super.key,
  });

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Card(
      child: Container(
        height: size.height * 0.25,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              info,
              style: textTheme.displayLarge,
            ),
            SizedBox(
              width: size.width * 0.35,
              child: Text(
                title,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
