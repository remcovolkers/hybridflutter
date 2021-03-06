import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:party_planner_app/models/partylist.dart';
import 'package:party_planner_app/storage/local_repo.dart';

import '../models/party.dart';

class PartyOverViewPage extends StatefulWidget {
  const PartyOverViewPage({Key? key}) : super(key: key);

  @override
  State<PartyOverViewPage> createState() => _PartyOverViewPageState();
}

class _PartyOverViewPageState extends State<PartyOverViewPage> {
  static PartyList partyList = PartyList();

  @override
  Widget build(BuildContext context) {
    /// so.. shouldPop makes sure the Party Overview Page can't be popped.
    /// Popping the overview page would setState into previous states.
    /// I don't know if this is the right way to fix it, but here we are.
    bool shouldPop = false;
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: FutureBuilder(
        //localrepo will initialize and fire off a boolean when done
        future: LocalRepo.isReady(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return buildLoading();
            default:
              if (snapshot.hasError) {
                return buildError(snapshot);
              } else {
                partyList.parties = LocalRepo.getPartyList().parties;
                return buildLoaded(partyList);
              }
          }
        },
      ),
    );
  }

  /// returns a column with parties, scrollable because the main (render) widget
  /// is wrapped around a single child scrollview (in main.dart)
  /// Passes partyindex so we can modify it in the rest of the application
  Widget buildLoaded(PartyList partyList) {
    return Column(
      children: [
        for (Party party in partyList.parties)
          PartyCard(
            partyIndex: partyList.parties.indexOf(party),
            party: party,
            handleSelection: handleSelection,
          )
      ],
    );
  }

  /// some state management
  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// some state management
  Widget buildError(AsyncSnapshot<Object?> snapshot) {
    return Text(
      'result: ${snapshot.data}',
    );
  }

  /// handling more_vert options and passing along arguments to routes.
  handleSelection(Party party, MenuItem menuItem, int partyIndex) {
    switch (menuItem.text) {
      case 'Remove Party':
        setState(() {
          partyList.parties.remove(party);
        });
        partyList.parties.remove(party);
        LocalRepo.savePartyListToLocalStorge(partyList);
        break;
      case 'Edit Party':
        Navigator.pushNamed(
          context,
          '/edit_party',
          arguments: [partyIndex, party],
        );
        break;
      case 'Attendee List':
        Navigator.pushNamed(
          context,
          '/add_attendees',
          arguments: partyList.parties[partyIndex],
        );
        break;
    }
  }
}

/// partycard, only used in party_overview_page so defined in this class file.
class PartyCard extends StatefulWidget {
  final Party party;
  final Function handleSelection;
  final int partyIndex;

  const PartyCard(
      {Key? key,
      required this.party,
      required this.handleSelection,
      required this.partyIndex})
      : super(key: key);

  @override
  State<PartyCard> createState() => _PartyCardState();
}

class _PartyCardState extends State<PartyCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: SizedBox(
            height: 150,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTitleWidget(context),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.party.partyDescription,
                      maxLines: 3,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: dateBuilder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Title and more vert icon
  Column buildTitleWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Text(
                widget.party.partyName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            PopupMenuButton<MenuItem>(
              child: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              tooltip: 'Select action',
              onSelected: (MenuItem menuItem) => widget.handleSelection(
                  widget.party, menuItem, widget.partyIndex),
              itemBuilder: (BuildContext context) {
                return _buildItems();
              },
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(2),
          child: Divider(
            thickness: 1.5,
          ),
        ),
      ],
    );
  }

  /// Build more_vert items
  List<PopupMenuItem<MenuItem>> _buildItems() {
    return MenuItems.menuList.map(
      (MenuItem menuItem) {
        return PopupMenuItem<MenuItem>(
          value: menuItem,
          child: Row(
            children: [
              Icon(
                menuItem.icon,
                size: 18,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 8,
                ),
              ),
              Text(menuItem.text)
            ],
          ),
        );
      },
    ).toList();
  }

  Column dateBuilder() {
    String date = DateFormat('yyyy-MM-dd').format(widget.party.occurDate);
    String time = DateFormat('hh:mm a').format(widget.party.occurDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DATE: ' + date,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'TIME: ' + time,
        ),
      ],
    );
  }
}

///Menu items for the more_vert menu
class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> menuList = [
    itemInvite,
    itemEdit,
    itemRemove,
  ];

  static const itemInvite = MenuItem(
    text: 'Attendee List',
    icon: Icons.people,
  );

  static const itemEdit = MenuItem(
    text: 'Edit Party',
    icon: Icons.edit,
  );
  static const itemRemove = MenuItem(
    text: 'Remove Party',
    icon: Icons.remove,
  );
}
