// ignore_for_file: prefer_null_aware_method_calls

import 'dart:async';

import 'package:ejc_frontend_dashboard/app/domains/dtos/team/detailed_team_composition.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/team/team_model.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/viewmodels.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_tile/list_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextFieldSearchPeople extends StatefulWidget
    implements PreferredSizeWidget {
  TextFieldSearchPeople({
    super.key,
    this.team,
    this.composition,
    this.isAddingToTeam,
  });

  final TeamModel? team;
  final bool? isAddingToTeam;

  List<DetailedTeamComposition>? composition;

  @override
  State<TextFieldSearchPeople> createState() => _TextFieldSearchPeopleState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TextFieldSearchPeopleState extends State<TextFieldSearchPeople> {
  late final SearchPeopleViewmodel searchPeopleViewmodel;
  late FocusNode _focusNode;
  final TextEditingController _controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    searchPeopleViewmodel = context.read<SearchPeopleViewmodel>();

    _focusNode = FocusNode()
      ..addListener(() async {
        await Future.delayed(
          const Duration(milliseconds: 30),
          () {
            if (!_focusNode.hasFocus) _removeOverlay();
          },
        );
      });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _overlayEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _controller.text.trim();
      if (query.isNotEmpty) {
        context
            .read<SearchPeopleViewmodel>()
            .onSeachPeopleByNameCommand
            .execute(query);
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  void _showOverlay() {
    _overlayEntry?.remove();
    final overlay = Overlay.of(context);
    final size = MediaQuery.of(context).size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width * .4,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, kToolbarHeight),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ListenableBuilder(
              listenable: searchPeopleViewmodel.onSeachPeopleByNameCommand,
              builder: (context, child) {
                final state = searchPeopleViewmodel.onSeachPeopleByNameCommand;

                return state.value.when(
                  running: () => Padding(
                    padding: EdgeInsets.all(size.width * .025),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  failure: (exception) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Erro: $exception'),
                    );
                  },
                  data: (people) {
                    if (people.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Nenhum resultado encontrado.'),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: people.length,
                      itemBuilder: (context, index) => //
                          ListTilePersonCard(
                        person: people[index],
                        resumed: true,
                        onPressed: _removeOverlay,
                        isAddingToTeam: widget.isAddingToTeam,
                        composition: widget.composition,
                      ),
                    );
                  },
                  orElse: SizedBox.shrink,
                );
              },
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: size.width * .4,
        child: TextField(
          focusNode: _focusNode,
          controller: _controller,
          onChanged: (_) => _onSearchChanged(),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            hintText: 'Buscar pessoa',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
