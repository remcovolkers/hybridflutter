import 'package:flutter/material.dart';
import 'package:party_planner_app/models/party.dart';
import 'package:intl/intl.dart';
import 'package:party_planner_app/models/partylist.dart';
import 'package:party_planner_app/storage/local_repo.dart';
import 'package:party_planner_app/utils/utils.dart';

class AddPartyPage extends StatefulWidget {
  const AddPartyPage({Key? key}) : super(key: key);

  @override
  State<AddPartyPage> createState() => _AddPartyPageState();
}

class _AddPartyPageState extends State<AddPartyPage> {
  ///adding a key for (some) form validation
  final _formKey = GlobalKey<FormState>();

  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _partyNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    _dateController.text = "";
    _timeController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formattedTimeOfDay = stringFromTimeOfDay(selectedTime, context);
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
                submitBtn(),
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
          _selectTime(context),
        },
      ),
    );
  }

  ElevatedButton submitBtn() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          writeParty(
              _partyNameController.text,
              _descriptionController.text,
              DateTime.parse(
                _dateController.text,
              ),
              timeOfDayfromString(_timeController.text));
        }
      },
      child: const Text(
        'Create party',
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
        addVerticalSpace(10),
      ],
    );
  }

  String? validateFormField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  void writeParty(String partyName, String partyDescription, DateTime date,
      TimeOfDay time) {
    PartyList partyList = LocalRepo.getPartyList();
    final toUTC =
        DateTime(date.year, date.month, date.year, time.hour, time.minute);
    Party party = Party(
      partyName: partyName,
      partyDescription: partyDescription,
      occurDate: toUTC,
    );
    partyList.parties.add(party);

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

    if (timeOfDay != null && timeOfDay != selectedTime) {
      String timeString = timeOfDay.format(context);
      setState(() {
        selectedTime = timeOfDay;
        _timeController.text = timeString;
      });
    }
  }
}
