import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/snackbar_type.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void showCustomSnackbar(
  BuildContext context, {
  required String message,
  SnackbarType type = SnackbarType.info,
}) {
  final String title;
  final ShadToast toast;

  switch (type) {
    case SnackbarType.success:
      title = 'Sucesso';
      toast = ShadToast(
        title: Text(title),
        description: Text(message),
      );
    case SnackbarType.error:
      title = 'Erro';
      toast = ShadToast.destructive(
        title: Text(title),
        description: Text(message),
      );
    case SnackbarType.info:
      title = 'Informação';
      toast = ShadToast(
        title: Text(title),
        description: Text(message),
      );
    case SnackbarType.warning:
      title = 'Atenção';
      toast = ShadToast.destructive(
        title: Text(title),
        description: Text(message),
      );
  }

  ShadToaster.of(context).show(toast);
}
