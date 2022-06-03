import 'package:flutter_test/flutter_test.dart';
import 'package:party_planner_app/models/party.dart';

void main() {
  test('JsonParty should be converted to Party model', () {
    DateTime date = DateTime.now();
    Map<String, dynamic> jsonParty = {
      'occurDate': date,
      'partyName': 'name',
      'partyDescription': 'description'
    };
    Party party = Party.fromJson(jsonParty);

    expect(party.occurDate, date);
    expect(party.partyName, 'name');
    expect(party.partyDescription, 'description');
  });

  test('Party should be converted to jsonparty', () {
    DateTime date = DateTime.now();
    Party party =
        Party(occurDate: date, partyName: 'test', partyDescription: 'test');
    Map<String, dynamic> jsonParty = party.toJsonEncodable();

    expect(jsonParty['occurDate'], date.toIso8601String());
    expect(jsonParty['partyName'], 'test');
    expect(jsonParty['partyDescription'], 'test');
  });
}
