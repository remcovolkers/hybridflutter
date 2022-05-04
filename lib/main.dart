import 'package:flutter/material.dart';
import 'package:party_planner_app/pages/add_party_page.dart';
import 'package:party_planner_app/pages/party_overview_page.dart';
import 'package:party_planner_app/storage/local_repo.dart';
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
      initialRoute: '/',
      routes: {
        '/add_party': (context) => const MyHomePage(
              title: 'Add a party',
              render: AddPartyPage(),
            ),
      },
      debugShowCheckedModeBanner: false,
      theme: Themes.themeData(),
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
        title: Text(
          widget.title,
        ),
      ),
      body: Column(
        children: [
          Container(
            child: widget.render,
          ),
        ],
      ),
      floatingActionButton: Visibility(
        //If we're not on the homepage, don't show the add party FAB.
        visible: ModalRoute.of(context)?.settings.name == '/' ? true : false,
        child: FloatingActionButton(
          onPressed: () => {
            Navigator.pushNamed(context, '/add_party'),
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
