import 'dart:developer';

import 'package:localstorage/localstorage.dart';
import 'package:party_planner_app/models/contactlist.dart';
import 'package:party_planner_app/models/party.dart';
import '../models/contact_model.dart';
import '../models/partylist.dart';

class LocalRepo {
  static LocalStorage storage = LocalStorage('partylist');

  static savePartyListToLocalStorge(PartyList partyList) async {
    await storage.setItem(
      'partylist',
      partyList.toJsonEncodable(),
    );
  }

  static saveContactListToLocalStorage(ContactList contactList) async {
    await storage.setItem(
      'contactlist',
      contactList.toJsonEncodable(),
    );
  }

  static ContactList getContactList() {
    ContactList contactList = ContactList();
    if (storage.getItem('contactlist') != null) {
      List<dynamic> jsonContacts = storage.getItem('contactlist') as List;
      for (var contact in jsonContacts) {
        contact = ContactModel.fromJson(contact);
        contactList.contacts.add(contact);
      }
    }
    return contactList;
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
