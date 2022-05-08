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

  static removeParty(Party party) async {
    PartyList partyList = getPartyList();

    ///there must be something wrong with my party model.
    ///the removeParty makes a new party somehow, this fixes it.
    ///This makes sure we can remove on Id and is more failsafe than comparing
    ///names.
    partyList.parties.removeWhere((element) => element.id == ++party.id);
    saveToLocalRepo(partyList);
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
