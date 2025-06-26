import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class InputName extends StatefulWidget {
  const InputName({
    required this.onChanged,
    required this.onSaved,
    super.key,
  });
  final void Function(String) onChanged;
  final void Function(String?) onSaved;

  @override
  State<InputName> createState() => _InputNameState();
}

class _InputNameState extends State<InputName> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return ShadInputFormField(
      constraints: BoxConstraints(
        maxWidth: size.width * .35,
      ),
      showCursor: true,
      placeholder: const Text('Nome ou parte do nome da pessoa'),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSaved,
    );
  }
}
