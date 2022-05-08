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
    return FutureBuilder(
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
    );
  }

  Widget buildLoaded(PartyList partyList) {
    return Column(
      children: [
        for (Party party in partyList.parties)
          PartyCard(
            party: party,
            handleSelection: handleSelection,
          )
      ],
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildError(AsyncSnapshot<Object?> snapshot) {
    return Text(
      'result: ${snapshot.data}',
    );
  }

  handleSelection(Party party, MenuItem menuItem) {
    switch (menuItem.text) {
      case 'Remove Party':
        setState(() {
          partyList.parties.remove(party);
        });
        LocalRepo.removeParty(party);
        break;
    }
  }
}

class PartyCard extends StatefulWidget {
  final Party party;
  final Function handleSelection;

  const PartyCard(
      {Key? key, required this.party, required this.handleSelection})
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
                    child: Text(
                      DateFormat('yyyy-mm-dd | kk:mm')
                          .format(widget.party.occurDate),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
              ),
              tooltip: 'Select action',
              onSelected: (MenuItem menuItem) =>
                  widget.handleSelection(widget.party, menuItem),
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

  List<PopupMenuItem<MenuItem>> _buildItems() {
    return MenuItems.menuList.map(
      (MenuItem menuItem) {
        return PopupMenuItem<MenuItem>(
          value: menuItem,
          child: Text(menuItem.text),
        );
      },
    ).toList();
  }
}

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
    text: 'Invite Guests',
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
