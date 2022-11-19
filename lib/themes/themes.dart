import 'package:calsync/themes/text_themes.dart';
import 'package:flutter/material.dart';

class CalsyncThemes {
  static ThemeData light = ThemeData(
    textTheme: CalsyncThemesText.calsyncTextThemeL,
    inputDecorationTheme: InputDecorationTheme(
      // fillColor: Color(0xff182231),
      contentPadding: EdgeInsets.only(left: 10),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFF0080)),
          borderRadius: BorderRadius.circular(10),
          gapPadding: 10),
      alignLabelWithHint: true,
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: Color(0xFF1C4572),
      dialHandColor: Color(0xff398AE5),
      dialTextColor: Color(0xFFC8C8C8),
      hourMinuteTextColor: Color(0xFFC8C8C8),
      dayPeriodBorderSide: BorderSide.none,
    ),

    accentColor: Color(0xFFFF0080),
    //FF3366),
    backgroundColor: Color(0xFF202836),
    scaffoldBackgroundColor: Color(0xFF398AE5),
    primaryColor: Color(0xff398AE5),
    primaryColorDark: Color(0xFF41424A),
    primaryColorLight: Color(0xFF1C4572),
    focusColor: Color(0xFFC8C8C8),
    disabledColor: Color(0xFF3176c6), //233142
  );

  static ThemeData dark = ThemeData(
    textTheme: CalsyncThemesText.calsyncTextThemeD,
    inputDecorationTheme: InputDecorationTheme(
      // fillColor: Color(0xff182231),
      contentPadding: EdgeInsets.only(left: 10),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink),
          borderRadius: BorderRadius.circular(10),
          gapPadding: 10),
      alignLabelWithHint: true,
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: Color(0xff182231),
      dialHandColor: Color(0xff182231),
      dialTextColor: Color(0xFFC8C8C8),
      dayPeriodColor: Color(0xFF41424A),
      hourMinuteTextColor: Color(0xFFC8C8C8),
      dayPeriodBorderSide: BorderSide.none,
      dayPeriodTextStyle: TextStyle(
        fontFamily: "Phenomena",
        color: Color(0xFFFF3366),
      ),
    ),

    disabledColor: Color(0xFF233142),
    //3176c6
    scaffoldBackgroundColor: Color(0xff182231),
    primaryColor: Color(0xff182231),
    primaryColorDark: Color(0xFF41424A),
    primaryColorLight: Color(0xFF35E636E),
    //1C4572),
    accentColor: Color(0xFFFF3366),
    focusColor: Color(0xFFC8C8C8),
    backgroundColor: Color(0xFF202836),
    primarySwatch: Colors.blue,
  );
}

// class ThemeNotifier extends ChangeNotifier {
//   final String key = "theme";
//   SharedPreferences prefs;
//   bool _darkTheme;

//   bool get darkTheme => _darkTheme;

//   ThemeNotifier() {
//     _darkTheme = true;
//     _loadFromPrefs();
//   }

//   toggleTheme() {
//     _darkTheme = !_darkTheme;
// //    globals.menuGradient=_darkTheme;
//     _saveToPrefs();
//     notifyListeners();
//   }

//   //Initializes shared preferences for theme and awaits for the instance
//   _initPrefs() async {
//     if (prefs == null) prefs = await SharedPreferences.getInstance();
//   }

//   //Loads the _darkTheme bool value from memory and notifies the listeners to change the theme of the application
//   _loadFromPrefs() async {
//     await _initPrefs();
//     _darkTheme = prefs.getBool(key) ?? true;
//     menuGradient = _darkTheme;
//     notifyListeners();
//   }

// //Saves _darkTheme bool value in memory after the preference has been initialized
//   _saveToPrefs() async {
//     await _initPrefs();
//     prefs.setBool(key, _darkTheme);
//   }
// }
