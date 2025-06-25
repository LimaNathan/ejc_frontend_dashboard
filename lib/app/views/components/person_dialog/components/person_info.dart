import 'dart:convert';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_dialog/components/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class PersonInfo extends StatefulWidget {
  const PersonInfo({
    required this.person,
    super.key,
  });
  final PersonModel person;
  @override
  State<PersonInfo> createState() => _PersonInfoState();
}

class _PersonInfoState extends State<PersonInfo> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);

    final birthDate =
        DateFormat('dd/MM/yyyy').format(widget.person.aniversario);
    final ejcDo = '${widget.person.ejcNumber}º Encontro de Jovens com Cristo';
    final numbers = widget.person.phones.map((e) => e).join(', ');

    final image = widget.person.photo != null
        ? Image.memory(
            base64Decode(
              widget.person.photo!,
            ),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        : null;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.person.name,
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
        SizedBox(height: size.height * 0.05),
        Row(
          children: [
            CircleAvatar(
              radius: size.width * 0.07,
              child: widget.person.photo != null
                  ? ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => showImageViewer(context, image!.image),
                          child: image,
                        ),
                      ),
                    )
                  : const Icon(HugeIcons.strokeRoundedUserList),
            ),
            SizedBox(width: size.width * 0.05),
            SizedBox(
              width: size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Data de nascimento: ',
                      style: textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: birthDate,
                          style: textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Círculo de origem: ',
                      style: textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: widget.person.circle.isEmpty
                              ? '--'
                              : widget.person.circle,
                          style: textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Fez o: ',
                      style: textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: ejcDo,
                          style: textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Contatos: ',
                      style: textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: numbers,
                          style: textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: size.height * .25,
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => showAdaptiveDialog<void>(
                      context: context,
                      builder: (context) => DeleteDialog(person: widget.person),
                    ),
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedDelete01,
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
