import 'package:flutter/material.dart';

class Themes {
  static ThemeData themeData() {
    return ThemeData(
      //---------------------------------------------------------------------
      //              Main theme / darkmode - lightmode
      //---------------------------------------------------------------------
      colorSchemeSeed: Colors.grey,
      brightness: Brightness.dark,
      //---------------------------------------------------------------------
      //                        Button theme
      //---------------------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
            return const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(10),
                right: Radius.circular(10),
              ),
            );
          }),
        ),
      ),
      //---------------------------------------------------------------------
      //                        Card theme
      //---------------------------------------------------------------------
      cardTheme: CardTheme(
        color: Colors.grey.shade500,
      ),
      //---------------------------------------------------------------------
      //                        Text theme
      //---------------------------------------------------------------------
    );
  }
}
