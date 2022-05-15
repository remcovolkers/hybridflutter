import 'dart:developer';
import 'package:party_planner_app/models/contact_model.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:party_planner_app/models/contactlist.dart';
import 'package:party_planner_app/storage/local_repo.dart';

class AddAttendeesPage extends StatefulWidget {
  const AddAttendeesPage({Key? key}) : super(key: key);

  @override
  State<AddAttendeesPage> createState() => _AddAttendeesPageState();
}

class _AddAttendeesPageState extends State<AddAttendeesPage> {
  ContactList contactList = ContactList();
  bool isSet = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setContacts(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return buildLoading();
          default:
            if (snapshot.hasError) {
              return buildError(snapshot);
            } else {
              contactList.contacts = LocalRepo.getContactList().contacts;
              return buildLoaded(contactList);
            }
        }
      },
    );
  }

  setContacts() async {
    var contacts = await ContactsService.getContacts(withThumbnails: false);
    for (var contact in contacts) {
      var displayName = contact.displayName;
      if (displayName != null) {
        ContactModel temp = ContactModel(displayName: displayName);
        setState(() {
          contactList.contacts.add(temp);
        });
      }
    }

    await LocalRepo.saveContactListToLocalStorage(contactList);

    setState(() {
      isSet = true;
    });
  }

  Widget buildLoading() {
    return Container();
  }

  Widget buildError(AsyncSnapshot<Object?> snapshot) {
    return Container();
  }

  Widget buildLoaded(ContactList contactList) {
    return Container();
  }
}
