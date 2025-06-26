import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SelectEncounter extends StatefulWidget {
  const SelectEncounter({
    required this.onChanged,
    super.key,
  });

  final void Function(int?)? onChanged;

  @override
  State<SelectEncounter> createState() => _SelectEncounterState();
}

class _SelectEncounterState extends State<SelectEncounter> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return ShadSelect<int>(
      placeholder: SizedBox(
        width: size.width,
        child: const Text(
          'Selecione o encontro que deseja filtrar',
        ),
      ),
      selectedOptionBuilder: (context, value) => SizedBox(
        width: size.width,
        child: Text('${value + 1}º encontro'),
      ),
      onChanged: widget.onChanged,
      options: [
        Padding(
          padding: EdgeInsets.all(size.width * .026),
          child: const Text('Selecione o encontro que você fez'),
        ),
        ...List.generate(
          5,
          (index) => ShadOption(
            value: index,
            child: Text('${index + 1}º encontro'),
          ),
        ),
      ],
    );
  }
}
