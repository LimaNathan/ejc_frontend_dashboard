import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/show_custom_snackbar.dart';
import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/snackbar_type.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/viewmodels.dart';
import 'package:ejc_frontend_dashboard/app/views/components/base/base_view_background.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_tile/list_view_builder_person_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

class PeopleListView extends StatefulWidget {
  const PeopleListView({super.key});

  @override
  State<PeopleListView> createState() => _PeopleListViewState();
}

class _PeopleListViewState extends State<PeopleListView> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return BaseViewBackground(
      child: BlocProvider(
        create: (context) {
          final bloc = context.read<PeopleViewmodelBloc>();

          if (bloc.state is! PeopleViewmodelLoaded) {
            bloc.add(
              FetchPaginatedPeople(
                page: 0,
                pageSize: 7,
              ),
            );
          }

          return bloc;
        },
        child: BlocBuilder<PeopleViewmodelBloc, PeopleViewmodelState>(
          builder: (context, state) {
            if (state is PeopleViewmodelLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is PeopleViewmodelError) {
              showCustomSnackbar(context, message: state.error);
            }
            if (state is PeopleViewmodelLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.02,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const TitlePeopleListView(),
                          ListViewBuilderPersonTile(
                            persons: state.page.items,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              if (state.page.currentPage == 0) {
                                showCustomSnackbar(
                                  context,
                                  message: 'Você já está na primeira página',
                                  type: SnackbarType.error,
                                );
                                return;
                              } else {
                                context.read<PeopleViewmodelBloc>().add(
                                      FetchPaginatedPeople(
                                        page: state.page.currentPage - 1,
                                        pageSize: 7,
                                      ),
                                    );
                              }
                            },
                            label: const Text('Anterior'),
                            icon: const Icon(
                              HugeIcons.strokeRoundedArrowLeft01,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              state.page.totalPages >= 7
                                  ? 7
                                  : state.page.totalPages,
                              (index) {
                                return InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () {
                                    if (index == state.page.currentPage) {
                                      return;
                                    } else {
                                      context.read<PeopleViewmodelBloc>().add(
                                            FetchPaginatedPeople(
                                              page: index,
                                              pageSize: 7,
                                            ),
                                          );
                                    }
                                  },
                                  child: Center(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 36,
                                      width: 36,
                                      margin: const EdgeInsets //
                                          .symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                        border: state.page.currentPage != index
                                            ? null
                                            : Border.all(
                                                color: colorScheme //
                                                    .surface
                                                    .withAlpha(100),
                                                width: 3,
                                              ),
                                        borderRadius: BorderRadius.circular(28),
                                        color: state.page.currentPage != index
                                            ? null
                                            : colorScheme.primary,
                                      ),
                                      child: Text(
                                        '${index + 1}',
                                        textAlign: TextAlign.justify,
                                        style: textTheme.bodyLarge?.copyWith(
                                          color: state.page.currentPage != index
                                              ? colorScheme.onPrimaryContainer
                                              : colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              if (state.page.currentPage + 1 ==
                                  state.page.totalPages) {
                                showCustomSnackbar(
                                  context,
                                  message: 'Você está na última página',
                                  type: SnackbarType.error,
                                );
                                return;
                              } else {
                                context.read<PeopleViewmodelBloc>().add(
                                      FetchPaginatedPeople(
                                        page: state.page.currentPage + 1,
                                        pageSize: 7,
                                      ),
                                    );
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
                ),
              );
            }
            return Container();
          },
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
