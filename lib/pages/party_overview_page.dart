import 'package:flutter/material.dart';
import 'package:party_planner_app/models/party.dart';
import 'package:party_planner_app/models/partylist.dart';
import 'package:party_planner_app/storage/local_repo.dart';

class PartyOverViewPage extends StatefulWidget {
  const PartyOverViewPage({Key? key}) : super(key: key);

  @override
  State<PartyOverViewPage> createState() => _PartyOverViewPageState();
}

class _PartyOverViewPageState extends State<PartyOverViewPage> {
  @override
  Widget build(BuildContext context) {
    return const PartyCard();
  }
}

class PartyCard extends StatefulWidget {
  const PartyCard({
    Key? key,
  }) : super(key: key);

  @override
  State<PartyCard> createState() => _PartyCardState();
}

class _PartyCardState extends State<PartyCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: InkWell(
          child: const Text('yo'),
          onTap: () => LocalRepo.getPartyList(),
        ),
      ),
    );
  }
}
