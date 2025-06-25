import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/show_custom_snackbar.dart';
import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/snackbar_type.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/viewmodels.dart';
import 'package:ejc_frontend_dashboard/app/views/components/base/base_view_background.dart';
import 'package:ejc_frontend_dashboard/app/views/components/no_data/no_data_component.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_tile/list_view_builder_person_tile.dart';
import 'package:ejc_frontend_dashboard/app/views/people/components/pagination_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

class PeopleListView extends StatefulWidget {
  const PeopleListView({super.key});

  @override
  State<PeopleListView> createState() => _PeopleListViewState();
}

class _PeopleListViewState extends State<PeopleListView> {
  late final PeopleViewmodel peopleViewmodel;
  @override
  void initState() {
    super.initState();
    peopleViewmodel = context.read<PeopleViewmodel>();

    peopleViewmodel //
        .onFetchPaginatedPeopleCommand
      ..execute(0, 7)
      ..addListener(listener);

    peopleViewmodel.onDeleteOne.addListener(listenerDeleteOne);
  }

  void listener() {
    final state = peopleViewmodel.onFetchPaginatedPeopleCommand;
    if (state.value.isFailure) {
      showCustomSnackbar(
        context,
        message: state.getCachedFailure().toString(),
      );
    }
  }

  void listenerDeleteOne() {
    if (peopleViewmodel.onDeleteOne.value.isSuccess) {
      peopleViewmodel //
          .onFetchPaginatedPeopleCommand
          .value
          .when(
        data: (data) => peopleViewmodel //
            .onFetchPaginatedPeopleCommand
            .execute(data.currentPage, 7),
        orElse: () {},
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    peopleViewmodel //
      ..onFetchPaginatedPeopleCommand.removeListener(listener)
      ..onDeleteOne.removeListener(listenerDeleteOne);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BaseViewBackground(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03,
            vertical: size.height * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitlePeopleListView(),
              ListenableBuilder(
                listenable: peopleViewmodel.onFetchPaginatedPeopleCommand,
                builder: (context, child) {
                  final state = peopleViewmodel //
                      .onFetchPaginatedPeopleCommand
                      .value;
                  return state.when(
                    running: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    data: (data) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data.items.isEmpty)
                          const Center(child: NoDataComponent()),
                        if (data.items.isNotEmpty)
                          ListViewBuilderPersonTile(persons: data.items),
                        if (data.items.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  if (data.currentPage == 0) {
                                    showCustomSnackbar(
                                      context,
                                      message:
                                          'Você já está na primeira página',
                                      type: SnackbarType.error,
                                    );
                                    return;
                                  } else {
                                    context
                                        .read<PeopleViewmodel>()
                                        .onFetchPaginatedPeopleCommand
                                        .execute(data.currentPage - 1, 7);
                                  }
                                },
                                label: const Text('Anterior'),
                                icon: const Icon(
                                  HugeIcons.strokeRoundedArrowLeft01,
                                ),
                              ),
                              PaginationBuilder(
                                totalPages: data.totalPages,
                                currentPage: data.currentPage,
                                onTap: (index) {
                                  context
                                      .read<PeopleViewmodel>()
                                      .onFetchPaginatedPeopleCommand
                                      .execute(index, 7);
                                },
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  if (data.currentPage + 1 == data.totalPages) {
                                    showCustomSnackbar(
                                      context,
                                      message: 'Você está na última página',
                                      type: SnackbarType.error,
                                    );
                                    return;
                                  } else {
                                    context
                                        .read<PeopleViewmodel>()
                                        .onFetchPaginatedPeopleCommand
                                        .execute(data.currentPage + 1, 7);
                                  }
                                },
                                label: const Text('Próximo'),
                                iconAlignment: IconAlignment.end,
                                icon: const Icon(
                                  HugeIcons.strokeRoundedArrowRight01,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    orElse: Container.new,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitlePeopleListView extends StatelessWidget {
  const TitlePeopleListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lista de pessoas cadastradas',
          style: textTheme.headlineLarge,
        ),
        Text(
          'Todas as pessoas cadastradas no sistema',
          style: textTheme //
              .bodyLarge
              ?.copyWith(
            color: colorScheme //
                .onSurface
                .withValues(alpha: 100),
          ),
        ),
      ],
    );
  }
}
