import 'dart:convert';

import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/show_custom_snackbar.dart';
import 'package:ejc_frontend_dashboard/app/shared/components/custom_snackbar/snackbar_type.dart';
import 'package:ejc_frontend_dashboard/app/utils/overlays/loading_overlay.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/home/home_viewmodel_bloc.dart';
import 'package:ejc_frontend_dashboard/app/views/components/base/base_view_background.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_dialog/person_dialog.dart';
import 'package:ejc_frontend_dashboard/app/views/home/components/basic_info_card.dart';
import 'package:ejc_frontend_dashboard/app/views/home/components/home_view_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) {
        final bloc = HomeViewmodelBloc(context.read())
          ..add(FetchAllDataEvent());

        return bloc;
      },
      child: BlocBuilder<HomeViewmodelBloc, HomeViewmodelState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => LoadingOverlay.show(context),
            );
          }

          if (state is HomeError) {
            LoadingOverlay.hide();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCustomSnackbar(
                context,
                message: state.message,
                type: SnackbarType.error,
              );
            });
          }

          if (state is HomeSuccess) {
            LoadingOverlay.hide();
            final untilThreeDays =
                '${state.data.totalAnswersUntilThreeDays ?? '--'}';
            final totalAwnsers = '${state.data.totalAnswers ?? '--'}';

            return BaseViewBackground(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.02,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeViewTitle(),
                      OverflowBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          BasicInfoCard(
                            info: totalAwnsers,
                            title: 'Formulários respondidos no total',
                          ),
                          BasicInfoCard(
                            info: untilThreeDays,
                            title: 'Formulários respondidos nos últimos 3 dias',
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'Últimos formulários preenchidos',
                        style: textTheme.headlineSmall,
                      ),
                      Visibility(
                        visible: state.data.lastAnswers != null,
                        replacement: const Center(
                          child: Text('Nenhum dado para mostrar'),
                        ),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.data.lastAnswers != null
                              ? state.data.lastAnswers!.length
                              : 0,
                          itemBuilder: (context, index) {
                            final person = state.data.lastAnswers![index];
                            try {
                              base64Decode(person.photo!);
                            } catch (e) {
                              person.photo = null;
                            }
                            final circle = person.circle.isEmpty
                                ? size.width < 600
                                    ? '--'
                                    : 'Círculo não informado'
                                : size.width < 600
                                    ? '${person.circle}'
                                        ' ${person.ejcNumber}'
                                    : 'Círculo ${person.circle}'
                                        ' ${person.ejcNumber}';

                            return InkWell(
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (context) => PersonDialog(
                                    person: person,
                                  ),
                                );
                              },
                              child: Card(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: size.height * 0.01,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.015,
                                    vertical: size.height * 0.015,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              child: person.photo != null
                                                  ? ClipOval(
                                                      child: Image.memory(
                                                        base64Decode(
                                                          person.photo!,
                                                        ),
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                      ),
                                                    )
                                                  : const Icon(
                                                      HugeIcons
                                                          .strokeRoundedUserList,
                                                    ),
                                            ),
                                            SizedBox(width: size.width * .02),
                                            Text(
                                              person.name,
                                              style: textTheme.labelLarge,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        flex: size.width < 600 ? 2 : 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${person.ejcNumber}º EJC',
                                              style: textTheme.bodySmall,
                                            ),
                                            SizedBox(width: size.width * .01),
                                            SizedBox(
                                              width: size.width * .1,
                                              child: Text(
                                                circle,
                                                style: textTheme.bodySmall,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
