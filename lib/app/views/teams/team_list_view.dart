import 'package:ejc_frontend_dashboard/app/views/components/base/base_view_background.dart';
import 'package:flutter/material.dart';

class TeamListView extends StatefulWidget {
  const TeamListView({super.key});

  @override
  State<TeamListView> createState() => _TeamListViewState();
}

class _TeamListViewState extends State<TeamListView> {
  @override
  Widget build(BuildContext context) {
    return const BaseViewBackground(
      child: Center(
        child: Text('Em desenvolvimento'),
      ),
    );
  }
}
