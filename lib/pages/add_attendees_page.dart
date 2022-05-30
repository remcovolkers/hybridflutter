import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:party_planner_app/models/contactlist.dart';
import 'package:collection/collection.dart';
import 'package:party_planner_app/storage/local_repo.dart';
import '../models/contact_model.dart';
import '../models/party.dart';

class AddAttendeesPage extends StatefulWidget {
  const AddAttendeesPage({Key? key}) : super(key: key);

  @override
  State<AddAttendeesPage> createState() => _AddAttendeesPageState();
}

class _AddAttendeesPageState extends State<AddAttendeesPage> {
  ContactList contactList = ContactList();
  List<String> invitees = [];

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

  Widget attendeeBuilder(ContactModel contact, Party party) {
    bool isInvited;

    invitees.contains(contact.displayName)
        ? isInvited = true
        : isInvited = false;

    return Card(
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
                    color: Colors.grey,
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

  /// handleAddAttendee zorgt ervoor dat we een lijst van contacts binnen krijgen,
  /// deze contacts worden vervolgens vergeleken met de party.attendees
  /// respectievelijk krijgen deze kaarten dan een remove of een add knop op de kaart.

  handleAddAttendee(ContactModel contact, Party party) async {
    party.attendees.add(contact.displayName);
    setState(() {
      invitees.add(contact.displayName);
    });
    LocalRepo.saveParty(party);
  }

  handleRemoveAttendee(ContactModel contact, Party party) async {
    party.attendees.remove(contact.displayName);
    setState(() {
      invitees.remove(contact.displayName);
    });
    LocalRepo.saveParty(party);
  }

  Widget buildLoaded(ContactList contactList) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: contactList.contacts.length,
      itemBuilder: (context, index) {
        Party party;
        if (ModalRoute.of(context)!.settings.arguments != null) {
          party = ModalRoute.of(context)!.settings.arguments as Party;
          return attendeeBuilder(contactList.contacts[index], party);
        }
        //return party doesn't exist
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          contactList = snapshot.data as ContactList;
          return buildLoaded(contactList);
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
