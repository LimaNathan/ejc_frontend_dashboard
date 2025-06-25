import 'package:ejc_frontend_dashboard/app/utils/routes/constants/constant_routes.dart';
import 'package:ejc_frontend_dashboard/app/viewmodel/auth/auth_viewmodel.dart';
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
  late final AuthViewmodel authViewmodel;

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
    authViewmodel = context //
        .read<AuthViewmodel>();

    authViewmodel.logoutCommand.addListener(_listener);
    super.initState();
  }

  void _listener() {
    if (authViewmodel.logoutCommand.value.isSuccess) {
      context.go(ConstantRoutes.initialRoute);
    }
  }

  @override
  void dispose() {
    super.dispose();

    authViewmodel.logoutCommand.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final user = Supabase.instance.client.auth.currentUser;
    final textTheme = Theme.of(context).textTheme;
    void onDestinationSelected(int index) {
      selectedIndexPage = index;

      pageController.animateToPage(
        index,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      );
      setState(() {});
    }

    void onPressedIcon() => setState(
          () => isNavigationExpanded = !isNavigationExpanded,
        );

    return Scaffold(
      bottomNavigationBar: size.width < 800
          ? BottomNavigationBar(
              currentIndex: selectedIndexPage,
              onTap: onDestinationSelected,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(HugeIcons.strokeRoundedHome01),
                  label: 'Página inicial',
                ),
                BottomNavigationBarItem(
                  icon: Icon(HugeIcons.strokeRoundedUserGroup),
                  label: 'Lista de pessoas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(HugeIcons.strokeRoundedGroup01),
                  label: 'Lista de equipes',
                ),
              ],
            )
          : null,
      appBar: AppBar(
        toolbarHeight: size.height * 0.09,
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: EdgeInsets.all(size.height * 0.01),
          child: Image.asset('assets/logo_ejc.png'),
        ),
        centerTitle: true,
        title: TextFieldSearchPeople(),
        actions: [
          Row(
            children: [
              const CircleAvatar(
                child: Icon(HugeIcons.strokeRoundedUser),
              ),
              const SizedBox(width: 10),
              if (size.width > 800)
                Text(
                  user?.email ?? '--',
                  style: textTheme.bodySmall,
                ),
              const SizedBox(width: 10),
              PopupMenuButton(
                onSelected: (value) {
                  if (value == 'logout') {
                    context.read<AuthViewmodel>().logoutCommand.execute();
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
      ),
      body: Row(
        children: [
          if (size.width > 800)
            NavigationRail(
              selectedIndex: selectedIndexPage,
              useIndicator: true,
              extended: isNavigationExpanded,
              onDestinationSelected: onDestinationSelected,
              leading: IconButton(
                onPressed: onPressedIcon,
                icon: HugeIcon(
                  icon: isNavigationExpanded
                      ? HugeIcons.strokeRoundedMenuCollapse
                      : HugeIcons.strokeRoundedMenu01,
                  color: colorScheme.scrim,
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(
                    HugeIcons.strokeRoundedHome01,
                    size: 16,
                  ),
                  label: Text('Página inicial'),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    HugeIcons.strokeRoundedUserGroup,
                    size: 16,
                  ),
                  label: Text('Lista de pessoas'),
                ),
                NavigationRailDestination(
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
    );
  }
}
