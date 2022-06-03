import 'dart:developer';

import 'package:localstorage/localstorage.dart';
import 'package:party_planner_app/models/party.dart';

import '../models/partylist.dart';

/// created this class because its cleaner to manage the localstorage
/// from one file.
class LocalRepo {
  static LocalStorage storage = LocalStorage('partylist');

  /// Saving a PartyList to the localstorage
  static savePartyListToLocalStorge(PartyList partyList) async {
    await storage.setItem(
      'partylist',
      partyList.toJsonEncodable(),
    );
  }

  ///getting the PartyList as PartyList
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

  /// Saving a party. This function is not perfect as it deletes an element
  /// with the same name, requiring the user to enter unique names for their
  /// parties. I couldn't get an ID system running on my Party Model because
  /// i'm creating parties everywhere and it felt like too much refactoring
  /// for the functionality added.
  static saveParty(Party party) async {
    PartyList partyList = getPartyList();
    partyList.parties
        .removeWhere((element) => element.partyName == party.partyName);
    partyList.parties.add(party);
    await savePartyListToLocalStorge(partyList);
  }

  static isReady() {
    return storage.ready;
  }
}
