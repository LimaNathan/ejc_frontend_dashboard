import 'package:ejc_frontend_dashboard/app/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SelectCircle extends StatefulWidget {
  const SelectCircle({
    required this.onChanged,
    super.key,
  });
  final void Function(String?)? onChanged;

  @override
  State<SelectCircle> createState() => _SelectCircleState();
}

class _SelectCircleState extends State<SelectCircle> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return ShadSelect<String>(
      placeholder: SizedBox(
        width: size.width,
        child: const Text('Selecione um círculo'),
      ),
      selectedOptionBuilder: (context, value) => SizedBox(
        width: size.width,
        child: Text(value),
      ),
      onChanged: widget.onChanged,
      options: [
        Padding(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * .026,
          ),
          child: const Text('Selecione algum círculo'),
        ),
        ...List.generate(
          AppConstants.circulos.length,
          (index) => ShadOption(
            value: AppConstants.circulos[index],
            child: Text(
              AppConstants.circulos[index],
            ),
          ),
        ),
      ],
    );
  }
}
