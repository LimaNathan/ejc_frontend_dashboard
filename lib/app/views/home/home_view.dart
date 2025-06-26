import 'package:ejc_frontend_dashboard/app/viewmodel/viewmodels.dart';
import 'package:ejc_frontend_dashboard/app/views/components/base/base_view_background.dart';
import 'package:ejc_frontend_dashboard/app/views/components/person_tile/list_view_builder_person_tile.dart';
import 'package:ejc_frontend_dashboard/app/views/home/components/basic_info_card.dart';
import 'package:ejc_frontend_dashboard/app/views/home/components/home_view_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewmodel homeViewmodel;
  @override
  void initState() {
    super.initState();

    homeViewmodel = context.read<HomeViewmodel>()
      ..fetchAllAwnsersCommand.execute()
      ..fetchLastFivePersonsCommand.execute()
      ..fetchLastUntilThreeDaysAnwsersCommand.execute();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return ListenableBuilder(
      listenable: homeViewmodel,
      builder: (context, child) {
        final untilThreeDays =
            homeViewmodel.fetchLastUntilThreeDaysAnwsersCommand;
        final totalAwnsers = homeViewmodel.fetchAllAwnsersCommand;
        final fetchLastFivePersons = homeViewmodel.fetchLastFivePersonsCommand;

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
                      ListenableBuilder(
                        listenable: totalAwnsers,
                        builder: (context, child) {
                          return BasicInfoCard(
                            isLoading: totalAwnsers.value.isRunning,
                            info: totalAwnsers.value.when(
                              data: (value) => value.toString(),
                              orElse: () => '--',
                            ),
                            title: 'Formulários respondidos no total',
                          );
                        },
                      ),
                      ListenableBuilder(
                        listenable: untilThreeDays,
                        builder: (context, child) {
                          return BasicInfoCard(
                            isLoading: untilThreeDays.value.isRunning,
                            info: untilThreeDays.value.when(
                              data: (value) => value.toString(),
                              orElse: () => '--',
                            ),
                            title: 'Formulários respondidos nos últimos 3 dias',
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    'Últimos formulários preenchidos',
                    style: textTheme.headlineSmall,
                  ),
                  ListenableBuilder(
                    listenable: fetchLastFivePersons,
                    builder: (context, child) {
                      return fetchLastFivePersons.value.when(
                        data: (data) {
                          return Visibility(
                            visible: data.isNotEmpty,
                            replacement: const Center(
                              child: Text('Nenhum dado para mostrar'),
                            ),
                            child: ListViewBuilderPersonTile(persons: data),
                          );
                        },
                        running: () =>
                            const Center(child: CircularProgressIndicator()),
                        orElse: Container.new,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
