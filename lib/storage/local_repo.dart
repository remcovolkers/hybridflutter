import 'dart:convert';

import 'package:localstorage/localstorage.dart';
import 'package:party_planner_app/models/party.dart';
import '../models/partylist.dart';

class LocalRepo {
  static LocalStorage storage = LocalStorage('partylist');

  static void saveToLocalRepo(PartyList partyList) {
    storage.setItem(
      'partylist',
      partyList.toJsonEncodable(),
    );
  }

  static PartyList getPartyList() {
    PartyList partyList = PartyList();
    if (storage.getItem('partylist') != null) {
      List<dynamic> jsonParties = storage.getItem('partylist') as List;

      for (var party in jsonParties) {
        //build in some nullchecks maybe
        party['occurDate'] = DateTime.parse(party['occurDate']);
        party = Party.fromJson(party);
        partyList.parties.add(party);
      }
      return partyList;
    }
    return partyList;
  }

  static clearList() {
    storage.clear();
  }
}
