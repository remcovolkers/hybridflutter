import 'package:flutter/material.dart';

Widget addVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

Widget addHorizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}

Widget addSpaceInRow(double width, double height) {
  return SizedBox(
    width: width,
    height: height,
  );
}

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

String stringFromTimeOfDay(TimeOfDay tod, BuildContext context) {
  final localizations = MaterialLocalizations.of(context);
  final formattedTimeOfDay = localizations.formatTimeOfDay(tod);
  return formattedTimeOfDay;
}
