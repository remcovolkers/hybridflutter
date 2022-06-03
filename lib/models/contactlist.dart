import 'contact_model.dart';

///Model to hold a contact list.
class ContactList {
  List<ContactModel> contacts = [];

  /// collector method so we can have 1 entry in the localstorage,
  /// that entry will be the list of contacts instead of unique entries in
  /// localstorage.
  toJsonEncodable() {
    List retVal = contacts.map((contact) {
      return contact.toJsonEncodable();
    }).toList();

    return retVal;
  }

  @override
  String toString() {
    String builder = "";
    for (var contact in contacts) {
      builder += contact.displayName += "\n";
    }
    return builder;
  }

  bool contains(ContactModel contact) {
    for (var element in contacts) {
      if (element == contact) {
        return true;
      }
    }
    return false;
  }

  void remove(ContactModel contact) {
    if (contacts.contains(contact)) {
      contacts.remove(contact);
    }
  }

  void add(ContactModel contact) {
    if (contacts.contains(contact)) {
      contacts.add(contact);
    }
  }
}
