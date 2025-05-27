import 'package:ejc_frontend_dashboard/app/views/components/base/base_view_background.dart';
import 'package:flutter/material.dart';

class PeopleListView extends StatefulWidget {
  const PeopleListView({super.key});

  @override
  State<PeopleListView> createState() => _PeopleListViewState();
}

class _PeopleListViewState extends State<PeopleListView> {
  @override
  Widget build(BuildContext context) {

    return const BaseViewBackground(
      child: Center(
        child: Text('Lista de pessoas'),
      ),
    );
  }
}
