import 'package:ejc_frontend_dashboard/app/utils/overlays/loading/loading_with_type_effect.dart';
import 'package:flutter/material.dart';

class LoadingOverlay {
  factory LoadingOverlay() => _instance;

  LoadingOverlay._internal();

  static final LoadingOverlay _instance = LoadingOverlay._internal();

  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context, {String? typingLabel}) {
    if (_overlayEntry != null) return;
    final width = MediaQuery.sizeOf(context).width;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black87,
              ),
            ),
            Center(
              child: LoadingWithTypingEffect(
                image: Image.asset(
                  'assets/logo_ejc.png',
                  width: width * .25,
                ),
                typingLabel: typingLabel ?? 'Carregando ',
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  bool get isVisible => _overlayEntry != null;
}
