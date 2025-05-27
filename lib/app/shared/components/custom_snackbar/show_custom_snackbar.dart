import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/snackbar_type.dart';
import 'package:flutter/material.dart';

void showCustomSnackbar(
  BuildContext context, {
  required String message,
  SnackbarType type = SnackbarType.info,
}) {
  final Color backgroundColor;
  final IconData iconData;

  switch (type) {
    case SnackbarType.success:
      backgroundColor = Colors.green.shade600;
      iconData = Icons.check_circle_outline;
    case SnackbarType.error:
      backgroundColor = Colors.red.shade600;
      iconData = Icons.error_outline;
    case SnackbarType.info:
      backgroundColor = Colors.blue.shade600;
      iconData = Icons.info_outline;
    case SnackbarType.warning:
      backgroundColor = Colors.orange.shade600;
      iconData = Icons.warning_amber_outlined;
  }

  ScaffoldMessenger.of(context) //
      .showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.startToEnd,
      hitTestBehavior: HitTestBehavior.translucent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  iconData,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
