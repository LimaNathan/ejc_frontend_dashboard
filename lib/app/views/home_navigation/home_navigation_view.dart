import 'package:ejc_frontend_dashboard/app/utils/routes/constants/constant_routes.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/auth/auth_viewmodel_bloc.dart';
import 'package:ejc_frontend_dashboard/app/views/home/home_view.dart';
import 'package:ejc_frontend_dashboard/app/views/home_navigation/components/text_field_search_people.dart';
import 'package:ejc_frontend_dashboard/app/views/people/people_list_view.dart';
import 'package:ejc_frontend_dashboard/app/views/teams/team_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeNavigationView extends StatefulWidget {
  const HomeNavigationView({super.key});

  @override
  State<HomeNavigationView> createState() => _HomeNavigationViewState();
}

class _HomeNavigationViewState extends State<HomeNavigationView> {
  late PageController pageController;
  bool isNavigationExpanded = false;
  int selectedIndexPage = 0;

  final pages = [
    const HomeView(),
    const PeopleListView(),
    const TeamListView(),
  ];

  @override
  void initState() {
    pageController = PageController(initialPage: selectedIndexPage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final user = Supabase.instance.client.auth.currentUser;
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<AuthViewmodelBloc, AuthViewmodelState>(
      listener: (context, state) {
        if (state is AuthUnlogged) {
          context.go(ConstantRoutes.initialRoute);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: true,
          title: const TextFieldSearchPeople(),
          actions: [
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(HugeIcons.strokeRoundedUser),
                ),
                const SizedBox(width: 10),
                Text(
                  user?.email ?? '--',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(width: 10),
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'logout') {
                      context.read<AuthViewmodelBloc>().add(LogoutEvent());
                    }
                  },
                  icon: const Icon(HugeIcons.strokeRoundedMenuTwoLine),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'logout',
                        child: Text('Sair'),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ],
          leading: Padding(
            padding: EdgeInsets.all(size.height * 0.01),
            child: Image.asset(
              'assets/logo_ejc.png',
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Row(
          children: [
            NavigationRail(
              indicatorColor: colorScheme.primary,
              selectedIndex: selectedIndexPage,
              useIndicator: true,
              extended: isNavigationExpanded,
              onDestinationSelected: (index) {
                selectedIndexPage = index;

                pageController.animateToPage(
                  index,
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 300),
                );
                setState(() {});
              },
              leading: IconButton(
                onPressed: () => setState(
                  () => isNavigationExpanded = !isNavigationExpanded,
                ),
                icon: HugeIcon(
                  icon: isNavigationExpanded
                      ? HugeIcons.strokeRoundedMenuCollapse
                      : HugeIcons.strokeRoundedMenu01,
                  color: colorScheme.scrim,
                ),
              ),
              unselectedIconTheme: IconThemeData(
                color: colorScheme.scrim,
              ),
              selectedIconTheme: IconThemeData(
                color: colorScheme.onPrimary,
              ),
              indicatorShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  padding: EdgeInsets.all(8),
                  icon: Icon(
                    HugeIcons.strokeRoundedHome01,
                    size: 16,
                  ),
                  label: Text('Página inicial'),
                ),
                NavigationRailDestination(
                  padding: EdgeInsets.all(8),
                  icon: Icon(
                    HugeIcons.strokeRoundedUserGroup,
                    size: 16,
                  ),
                  label: Text('Lista de pessoas'),
                ),
                NavigationRailDestination(
                  padding: EdgeInsets.all(8),
                  icon: Icon(
                    HugeIcons.strokeRoundedGroup01,
                    size: 16,
                  ),
                  label: Text('Lista de equipes'),
                ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
