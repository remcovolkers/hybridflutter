import 'package:flutter/material.dart';

// vertical spacing
SizedBox addVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

// horizontal spacing
SizedBox addHorizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}

//A row item needs height and width
SizedBox addSpaceInRow(double width, double height) {
  return SizedBox(
    width: width,
    height: height,
  );
}

// convert String to TimeOfDay
TimeOfDay timeOfDayfromString(String time) {
  int hh = 0;
  if (time.endsWith('PM')) hh = 12;
  time = time.split(' ')[0];
  return TimeOfDay(
    hour: hh +
        int.parse(time.split(":")[0]) %
            24, // in case of a bad time format entered manually by the user
    minute: int.parse(time.split(":")[1]) % 60,
  );
}

// convert TimeOfDay to String
String stringFromTimeOfDay(TimeOfDay tod, BuildContext context) {
  final localizations = MaterialLocalizations.of(context);
  final formattedTimeOfDay = localizations.formatTimeOfDay(tod);
  return formattedTimeOfDay;
}
