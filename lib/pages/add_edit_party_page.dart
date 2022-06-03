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

  /// Give TimeOfDay a value so it's not null.
  TimeOfDay selectedTime = TimeOfDay.now();

  /// Same for this DateTime
  DateTime selectedDate = DateTime.now();

  ///TextEdittingControllers...
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _partyNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  /// This page is being used by create and edit. We want some boolean to tell
  /// us what the purpose of it's creation is. Passing along an edit boolean if
  /// we're editting.
  bool isEdit = false;

  @override
  void initState() {
    _timeController.text = "";
    _dateController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Initializing Partyindex to int NULL because we want to nullcheck
    /// the ModalRoute args. Nullsafety.
    int partyIndex = -1;

    /// Partyholder.
    Party party;

    /// Getting the party from the arguments. Index to have control over
    /// The LocalRepo.
    if (ModalRoute.of(context)!.settings.arguments != null) {
      List<dynamic> args = ModalRoute.of(context)!.settings.arguments as List;
      party = args[1];
      partyIndex = args[0];

      /// if we got a party passed along it means we're editting.
      /// Set default values and isEdit to true.
      setState(() {
        isEdit = true;
        String date = DateFormat('yyyy-MM-dd').format(party.occurDate);
        String time = DateFormat('hh:mm a').format(party.occurDate);

        /// If the fields don't hold value, edit them to the party's value
        /// Else allow the user to enter their own values
        if (_timeController.text == "" &&
            _descriptionController.text == "" &&
            _partyNameController.text == "") {
          _dateController.text = date;
          _timeController.text = time;
          _partyNameController.text = party.partyName;
          _descriptionController.text = party.partyDescription;
        }
      });
    }

    /// Some trickery with a package I used. Don't remember why this was
    /// neccessary. But it is.
    final formattedTimeOfDay = stringFromTimeOfDay(
      selectedTime,
      context,
    );

    /// Build the form, some validation present
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

  /// Build the datepicker, some form validation again.
  /// Value is readonly. Field is clickable, which will start the
  /// dialogue. Dates are just guesstemitates of what we think are reasonable
  /// times you can plan ahead for a party.
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

          /// if user actually entered a date.
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

  /// Same stuff different day for timepicker (datepicker docu)
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

  /// Call to action, will writeParty to the localstorage if form is valid.
  /// If its an edit party text in button will represent this neatly.
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

  /// TextFormField builder. It works for both TextEditFields.
  /// Might not be scalable but i think is more than fine for this project.
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

        /// AddVerticalSpace and all other space'adders' are defined in the
        /// Utils class.
        addVerticalSpace(
          10,
        ),
      ],
    );
  }

  /// some validation :), checks if a field is not empty and provides the user
  /// with an 'error'
  String? validateFormField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field can\'t be empty.';
    }
    return null;
  }

  /// Writes a party to the localstorage. Does some data handling. And navigates
  /// to the home page.
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

    LocalRepo.savePartyListToLocalStorge(partyList);
    Navigator.pushReplacementNamed(
      context,
      '/',
    );
  }

  /// Timepicker package basic syntax. Formats the picked time to a string,
  /// so we can use it as text in the textfield. Saves it as TimeOfDay in
  /// the selectedTime variable so we can use it to write to the localstorage.
  /// (writeParty)
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

  /// Fixes situations where there is a 0 involved in the time. (e.g. 12:05 was
  /// saved as 12:5. The string provided will hold either an hour or a minute
  /// if length == 1 (so not 01 but 1 or 5 instead of 05) it adds a zero and
  /// returns)
  String fixTimeDateFormat(String needsFixing) {
    String fixed = needsFixing;
    if (needsFixing.length == 1) {
      fixed = '0' + needsFixing;
    }
    return fixed;
  }

  /// creates a dateparser string by the time provided from user. Since Time
  /// and Date are treated as 2 seperate entry values they're being brought
  /// back together in this function in a way we can revert it to a full
  /// DateTime String which we require in our party model.
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
