import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:party_planner_app/models/contactlist.dart';
import 'package:party_planner_app/storage/local_repo.dart';
import '../models/contact_model.dart';
import '../models/party.dart';

class AddAttendeesPage extends StatefulWidget {
  const AddAttendeesPage({Key? key}) : super(key: key);

  @override
  State<AddAttendeesPage> createState() => _AddAttendeesPageState();
}

class _AddAttendeesPageState extends State<AddAttendeesPage> {
  /// Contact List we will store our phone contacts in
  ContactList contactList = ContactList();

  /// Holder for invitees per party
  List<String> invitees = [];

  /// Uses contacts_service to get Contacts. Stores contacts so we can use 'm
  Future<ContactList> setContacts() async {
    ContactList contactList = ContactList();

    var contacts = await ContactsService.getContacts(withThumbnails: false);
    for (var contact in contacts) {
      var displayName = contact.displayName;
      if (displayName != "" && displayName != null) {
        ContactModel temp = ContactModel(displayName: displayName);
        contactList.contacts.add(temp);
      }
    }
    return contactList;
  }

  /// Builds card, has checks for invited or not
  Card attendeeCard(ContactModel contact, Party party) {
    bool isInvited;

    invitees.contains(contact.displayName)
        ? isInvited = true
        : isInvited = false;

    return Card(
      color: isInvited ? Colors.green : null,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              contact.displayName,
            ),
            isInvited
                ? IconButton(
                    color: Colors.deepOrange,
                    onPressed: () async {
                      handleRemoveAttendee(contact, party);
                    },
                    icon: const Icon(
                      Icons.person_remove,
                    ),
                  )
                : IconButton(
                    color: Colors.white54,
                    onPressed: () async {
                      handleAddAttendee(contact, party);
                    },
                    icon: const Icon(
                      Icons.person_add,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  /// Handles the add button, stores it in LocalStorage and rebuilds page
  handleAddAttendee(ContactModel contact, Party party) async {
    party.attendees.add(contact.displayName);
    setState(() {
      invitees.add(contact.displayName);
    });
    LocalRepo.saveParty(party);
  }

  /// Handles the remove button, removes it from LocalStorage and rebuilds page
  handleRemoveAttendee(ContactModel contact, Party party) async {
    party.attendees.remove(contact.displayName);
    setState(() {
      invitees.remove(contact.displayName);
    });
    LocalRepo.saveParty(party);
  }

  /// Our scrollable list of contacts.
  Column buildLoaded(ContactList contactList, Party party) {
    List<Widget> attendeeCards = [];
    for (var name in contactList.contacts) {
      attendeeCards.add(attendeeCard(name, party));
    }
    return Column(
      children: attendeeCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    Party party = ModalRoute.of(context)!.settings.arguments as Party;
    invitees = party.attendees;

    return FutureBuilder(
      future: setContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          contactList = snapshot.data as ContactList;
          return buildLoaded(contactList, party);
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
