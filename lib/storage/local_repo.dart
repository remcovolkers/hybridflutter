import 'dart:developer';

import 'package:localstorage/localstorage.dart';
import 'package:party_planner_app/models/party.dart';
import '../models/partylist.dart';

class LocalRepo {
  static LocalStorage storage = LocalStorage('partylist');

  static saveToLocalRepo(PartyList partyList) async {
    await storage.setItem(
      'partylist',
      partyList.toJsonEncodable(),
    );
  }

  static PartyList getPartyList() {
    PartyList partyList = PartyList();
    if (storage.getItem('partylist') != null) {
      List<dynamic> jsonParties = storage.getItem('partylist') as List;

      for (var party in jsonParties) {
        if (party['occurDate'].runtimeType == String) {
          party['occurDate'] = DateTime.parse(party['occurDate']);
        }
        party = Party.fromJson(party);
        partyList.parties.add(party);
      }
    }
    return partyList;
  }

  static clearList() {
    storage.clear();
  }

  static isReady() {
    return storage.ready;
  }
}
