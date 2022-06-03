import 'package:flutter_test/flutter_test.dart';
import 'package:party_planner_app/models/party.dart';
import 'package:party_planner_app/models/partylist.dart';

void main() {
  PartyList partyList = PartyList();
  partyList.parties = [
    Party(
        occurDate: DateTime.now(),
        partyName: 'test1',
        partyDescription: 'test2'),
    Party(
        occurDate: DateTime.now(),
        partyName: 'test1',
        partyDescription: 'test2')
  ];
  test('PartyList holds parties and elements are Party models', () {
    expect(partyList.parties.length, 2);
    expect(partyList.parties[0].partyName, 'test1');
    expect(partyList.parties[1].runtimeType, Party);
  });
  test('PartyList are able to be saved in localstorage (toJsonEncodable)', () {
    List<dynamic> partyListJson = partyList.toJsonEncodable();
    expect(partyListJson.length, 2);
  });
  test('Partylist object is easily convertable to a party model', () {
    List<dynamic> partyListJson = partyList.toJsonEncodable();
    Party party = Party.fromJson(partyListJson[0]);
    expect(party.partyName, 'test1');
  });
}
