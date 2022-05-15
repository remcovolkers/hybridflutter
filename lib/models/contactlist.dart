import 'contact_model.dart';

class ContactList {
  List<ContactModel> contacts = [];

  /// collector method so we can have 1 entry in the localstorage,
  /// that entry will be the list of parties instead of unique entries in
  /// localstorage.
  toJsonEncodable() {
    List retVal = contacts.map((contact) {
      return contact.toJsonEncodable();
    }).toList();

    return retVal;
  }

  ///for readability during debugging, been using alot of print(partyList)
  @override
  String toString() {
    String builder = "";
    for (var contact in contacts) {
      builder += contact.displayName += "\n";
    }
    return builder;
  }
}
