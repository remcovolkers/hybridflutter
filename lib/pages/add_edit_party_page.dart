import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:party_planner_app/models/party.dart';
import 'package:intl/intl.dart';
import 'package:party_planner_app/models/partylist.dart';
import 'package:party_planner_app/storage/local_repo.dart';
import 'package:party_planner_app/utils/utils.dart';

class AddEditPartyPage extends StatefulWidget {
  const AddEditPartyPage({Key? key}) : super(key: key);

  @override
  State<AddEditPartyPage> createState() => _AddEditPartyPageState();
}

class _AddEditPartyPageState extends State<AddEditPartyPage> {
  ///adding a key for (some) form validation
  final _formKey = GlobalKey<FormState>();

  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _partyNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    _timeController.text = "";
    _dateController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int partyIndex = -1;
    Party party;

    if (ModalRoute.of(context)!.settings.arguments != null) {
      List<dynamic> args = ModalRoute.of(context)!.settings.arguments as List;
      party = args[1];
      partyIndex = args[0];

      setState(() {
        isEdit = true;
        String date = DateFormat('yyyy-MM-dd').format(party.occurDate);
        String time = DateFormat('hh:mm a').format(party.occurDate);

        if (_timeController.text == "") {
          _dateController.text = date;
          _timeController.text = time;
        }
      });
      _descriptionController.text = party.partyDescription;
      _partyNameController.text = party.partyName;
    }

    final formattedTimeOfDay = stringFromTimeOfDay(
      selectedTime,
      context,
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                textFormFieldInit(_partyNameController, 'Party name'),
                textFormFieldInit(_descriptionController, 'Party Description'),
                Row(
                  children: [
                    buildDatePicker(context),
                    addSpaceInRow(10, 10),
                    buildTimePicker(
                      formattedTimeOfDay,
                      context,
                    ),
                  ],
                ),
                submitBtn(partyIndex),
              ],
            ),
          )
        ],
      ),
    );
  }

  Flexible buildDatePicker(BuildContext context) {
    return Flexible(
      child: TextFormField(
        controller: _dateController,
        validator: validateFormField,
        readOnly: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: DateFormat(
            'yyyy-MM-dd',
          ).format(
            DateTime.now(),
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2024),
          );

          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            setState(() {
              _dateController.text = formattedDate;
            });
          }
        },
      ),
    );
  }

  Flexible buildTimePicker(String formattedTimeOfDay, BuildContext context) {
    return Flexible(
      child: TextFormField(
        controller: _timeController,
        validator: validateFormField,
        readOnly: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: formattedTimeOfDay,
        ),
        onTap: () => {
          _selectTime(
            context,
          ),
        },
      ),
    );
  }

  ElevatedButton submitBtn(int partyIndex) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          writeParty(
            partyIndex,
            _partyNameController.text,
            _descriptionController.text,
            DateTime.parse(
              _dateController.text,
            ),
            timeOfDayfromString(
              _timeController.text,
            ),
          );
        }
      },
      child: Text(
        isEdit ? 'Update party' : 'Create Party',
      ),
    );
  }

  Column textFormFieldInit(
      TextEditingController textEditingController, String placeholderText) {
    return Column(
      children: [
        TextFormField(
          maxLength: textEditingController == _partyNameController ? 30 : 100,
          controller: textEditingController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: placeholderText,
          ),
          validator: validateFormField,
        ),
        addVerticalSpace(
          10,
        ),
      ],
    );
  }

  String? validateFormField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  void writeParty(
    int partyIndex,
    String newName,
    String partyDescription,
    DateTime date,
    TimeOfDay time,
  ) {
    PartyList partyList = LocalRepo.getPartyList();
    final toUTC = DateTime.parse(dateParser(date, time));

    Party party = Party(
      partyName: newName,
      partyDescription: partyDescription,
      occurDate: toUTC,
    );

    if (isEdit) {
      setState(() {
        partyList.parties[partyIndex].partyName = newName;
        partyList.parties[partyIndex].partyDescription = partyDescription;
        partyList.parties[partyIndex].occurDate = toUTC;
      });
    } else {
      setState(() {
        partyList.parties.add(party);
      });
    }

    LocalRepo.saveToLocalRepo(partyList);
    Navigator.pushReplacementNamed(
      context,
      '/',
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (timeOfDay != null) {
      String timeString = timeOfDay.format(context);

      setState(() {
        selectedTime = timeOfDay;
        _timeController.text = timeString;
      });
    }
  }

  String fixTimeDateFormat(String needsFixing) {
    String fixed = needsFixing;
    if (needsFixing.length == 1) {
      fixed = '0' + needsFixing;
    }
    return fixed;
  }

  String dateParser(date, time) {
    String dateParserString = date.year.toString() +
        '-' +
        fixTimeDateFormat(
          date.month.toString(),
        ) +
        '-' +
        fixTimeDateFormat(
          date.day.toString(),
        ) +
        ' ' +
        fixTimeDateFormat(
          time.hour.toString(),
        ) +
        ':' +
        fixTimeDateFormat(
          time.minute.toString(),
        ) +
        '00';

    return dateParserString;
  }
}
