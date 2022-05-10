import 'package:flutter/material.dart';
import 'package:party_planner_app/pages/add_edit_party_page.dart';
import 'package:party_planner_app/pages/party_overview_page.dart';

import 'package:party_planner_app/themes.dart';

void main() {
  runApp(
    const PartyPlanner(),
  );
}

class PartyPlanner extends StatelessWidget {
  const PartyPlanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/add_party': (context) => const MyHomePage(
              title: 'Add a party',
              render: AddEditPartyPage(),
            ),
        '/edit_party': (context) => const MyHomePage(
              title: 'Edit Party',
              render: AddEditPartyPage(),
            )
      },
      debugShowCheckedModeBanner: false,
      theme: Themes().themeData(),
      home: const MyHomePage(
        title: 'Party Planner',
        render: PartyOverViewPage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.render,
  }) : super(key: key);

  final String title;
  final Widget render;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Visibility(
            visible:
                ModalRoute.of(context)!.settings.name == '/' ? true : false,
            child: IconButton(
              onPressed: () => {
                Navigator.pushNamed(context, '/add_party'),
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
        automaticallyImplyLeading:
            //TODO: FIX BEFORE HAND IN
            ModalRoute.of(context)?.settings.name == '/' ? false : true,
        title: Text(
          widget.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.render,
          ],
        ),
      ),
    );
  }
}
