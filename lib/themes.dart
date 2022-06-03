import 'package:flutter/material.dart';

/// declare default styling for the app and default colors. Just theme in
/// general! Could be more extensive but since the app is quite small
class Themes {
  ThemeData themeData() {
    return ThemeData(
      //---------------------------------------------------------------------
      //              Main theme / darkmode - lightmode
      //---------------------------------------------------------------------
      colorSchemeSeed: Colors.blueGrey,
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
        color: Colors.blueGrey[500],
      ),
      dividerTheme: DividerThemeData(
        color: Colors.blueGrey[700],
      ),

      //---------------------------------------------------------------------
      //                        Icon theme
      //---------------------------------------------------------------------
      iconTheme: IconThemeData(
        color: Colors.blueGrey[500],
      ),
    );
  }
}
