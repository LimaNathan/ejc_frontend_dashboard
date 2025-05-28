import 'package:flutter/material.dart';

class LoginBackground extends StatefulWidget {
  const LoginBackground({
    super.key,
  });

  @override
  State<LoginBackground> createState() => _LoginBackgroundState();
}

class _LoginBackgroundState extends State<LoginBackground> {
  bool canSeeImage = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: size.height * 0.01,
        ),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.5),
              blurRadius: 100,
              offset: const Offset(5, 5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            Image.asset(
              'assets/vector_psap.png',
              isAntiAlias: true,
              height: size.height * 5,
              filterQuality: FilterQuality.high,
              color: colorScheme.onPrimary,
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.dst,
            ),
            Positioned(
              top: size.height * 0.05,
              left: size.width * 0.05,
              right: size.width * 0.05,
              child: Row(
                children: [
                  Image.asset(
                    'assets/logo_ejc.png',
                    height: size.height * .025,
                  ),
                  SizedBox(width: size.width * .009),
                  Text(
                    'EJC',
                    style: textTheme //
                        .headlineSmall
                        ?.copyWith(
                      color: colorScheme.primaryFixedDim,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: size.height * 0.05,
              left: size.width * 0.05,
              right: size.width * 0.05,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '“A única coisa que nós temos '
                    'que pedir a Deus na oração é a vontade de ser santos.”',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.primaryFixedDim,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.015),
                  Text(
                    'Carlo Acutis',
                    style: TextStyle(
                      color: colorScheme.secondaryFixedDim,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Text(
                    'SGE',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.primaryFixedDim,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    color: colorScheme //
                        .onPrimary
                        .withValues(alpha: 200),
                  ),
                  Text(
                    'Sistema de Gerenciamento de Encontreiros',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primaryFixedDim,
                      fontSize: 10,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
