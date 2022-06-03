import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:party_planner_app/pages/add_attendees_page.dart';
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
      /// Routes
      routes: {
        '/add_party': (context) => const MyHomePage(
              title: 'Add a party',
              render: AddEditPartyPage(),
            ),
        '/edit_party': (context) => const MyHomePage(
              title: 'Edit Party',
              render: AddEditPartyPage(),
            ),
        '/add_attendees': (context) => const MyHomePage(
              title: 'Contact List',
              render: AddAttendeesPage(),
            ),
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
  void initState() {
    super.initState();
    _askPermissions("");
  }

  @override
  Widget build(BuildContext context) {
    /// isOverviewPage to indicate what appbar icons we should show
    bool isOverviewPage = ModalRoute.of(context)?.settings.name == '/';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            color: Theme.of(context).iconTheme.color,
            onPressed: () => {
              isOverviewPage
                  ? Navigator.pushNamed(
                      context,
                      '/add_party',
                    )
                  : Navigator.pop(context),
            },
            icon: Icon(
              isOverviewPage ? Icons.add : Icons.arrow_back,
            ),
          ),
        ],
        automaticallyImplyLeading: false,
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

  /// need permissions to see phone contacts
  Future<void> _askPermissions(String routeName) async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      if (routeName != "") {
        Navigator.of(context).pushNamed(routeName);
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  /// handling invalid permissions will show a snackbar
  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(
        content: Text(
          'Access to contact data denied',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar,
      );
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar = SnackBar(
        content: Text(
          'Contact data not available on device',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
