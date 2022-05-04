import 'package:flutter/material.dart';
import 'package:party_planner_app/models/partylist.dart';
import 'package:party_planner_app/storage/local_repo.dart';

import '../models/party.dart';

class PartyOverViewPage extends StatefulWidget {
  const PartyOverViewPage({Key? key}) : super(key: key);

  @override
  State<PartyOverViewPage> createState() => _PartyOverViewPageState();
}

class _PartyOverViewPageState extends State<PartyOverViewPage> {
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
              PartyList partyList = LocalRepo.getPartyList();
              return buildLoaded(partyList);
            }
        }
      },
    );
  }

  Widget buildLoaded(PartyList partyList) {
    return Column(
      children: [
        for (Party party in partyList.parties) PartyCard(party: party)
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
}

class PartyCard extends StatefulWidget {
  final Party party;
  const PartyCard({Key? key, required this.party}) : super(key: key);

  @override
  State<PartyCard> createState() => _PartyCardState();
}

class _PartyCardState extends State<PartyCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Card(
        child: Text(widget.party.partyName),
      ),
    );
  }
}
