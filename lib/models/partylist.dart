import 'package:party_planner_app/models/party.dart';

class PartyList {
  List<Party> parties = [];

  /// collector method so we can have 1 entry in the localstorage,
  /// that entry will be the list of parties instead of unique entries in
  /// localstorage.
  toJsonEncodable() {
    List retVal = parties.map((party) {
      return party.toJsonEncodable();
    }).toList();
    return retVal;
  }

  @override
  String toString() {
    String builder = "";
    for (var party in parties) {
      builder += '-------------------\n';
      builder += party.toString() + "\n";
      builder += '-------------------\n';
    }
    return builder;
  }
}
