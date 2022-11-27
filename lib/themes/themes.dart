// import 'package:calsync/themes/text_themes.dart';
import 'text_themes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalsyncThemes extends ChangeNotifier {
  CalsyncThemes._(); // private constructor t prevent creating an instance

  static ThemeData light = ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: CalsyncThemesText.calsyncTextThemeL,
    inputDecorationTheme: InputDecorationTheme(
      // fillColor: Color(0xff182231),
      contentPadding: const EdgeInsets.only(left: 10),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFF0080)),
          borderRadius: BorderRadius.circular(10),
          gapPadding: 10),
      alignLabelWithHint: true,
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: Color(0xFF1C4572),
      dialHandColor: Color(0xff398AE5),
      dialTextColor: Color(0xFFC8C8C8),
      hourMinuteTextColor: Color(0xFFC8C8C8),
      dayPeriodBorderSide: BorderSide.none,
    ),
    // accentColor: const Color(0xFFFF0080),
    //FF3366),
    backgroundColor: const Color(0xFF202836),
    scaffoldBackgroundColor: const Color(0xFF398AE5),
    primaryColor: const Color(0xff398AE5),
    primaryColorDark: const Color(0xFF41424A),
    primaryColorLight: const Color(0xFF1C4572),
    focusColor: const Color(0xFFC8C8C8),
    disabledColor: const Color(0xFF3176c6),
    //233142
    bottomAppBarTheme: const BottomAppBarTheme(
      elevation: 20.0,
      color: Colors.brown,
      shape: CircularNotchedRectangle(),
    ),
    brightness: Brightness.light,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: ThemeData.light(useMaterial3: true).disabledColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colors.amber,
        circularTrackColor: Colors.greenAccent,
        linearMinHeight: 2.0,
        refreshBackgroundColor: Colors.orange),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: CalsyncThemesText.calsyncTextThemeD,
    errorColor: Colors.red,
    inputDecorationTheme: InputDecorationTheme(
      // fillColor: Color(0xff182231),
      contentPadding: const EdgeInsets.only(left: 10),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.pink),
        borderRadius: BorderRadius.circular(10),
        gapPadding: 10,
      ),
      focusColor: Colors.pink,
      alignLabelWithHint: true,
      border: InputBorder.none,
      errorBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: ThemeData.dark(useMaterial3: true).errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ThemeData.light().errorColor),
      ),
      errorStyle: ThemeData.dark().textTheme.bodyText2,
    ),
    timePickerTheme: const TimePickerThemeData(
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
    disabledColor: const Color(0xFF233142),
    //3176c6
    scaffoldBackgroundColor: const Color(0xff182231),
    primaryColor: const Color(0xff182231),
    primaryColorDark: const Color(0xFF41424A),
    primaryColorLight: const Color(0xFF35E636E),
    //1C4572),
    // accentColor: const Color(0xFFFF3366),
    focusColor: const Color(0xFFC8C8C8),
    backgroundColor: const Color(0xFF202836),
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 20.0,
      color: ThemeData.dark().backgroundColor,
      shape: CircularNotchedRectangle(),
    ),
  );
}

class CalsyncThemeNotification extends ChangeNotifier {
  static const String _themeKey = "theme_key";
  bool _darkTheme = false;
  CalsyncThemeNotification() {
    _darkTheme = true;
    getThemeSharedPref();
  }
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//   Future<SharedPreferences> initPrefs() async {
//     _prefs ??= (await SharedPreferences.getInstance());
//   }

  Future<void> setThemeSharedPref() async {
    // final SharedPreferences prefs = await _prefs; //Initializes shared preferences in current scope for theme and awaits for the instance
    // final theme = prefs.setBool(_themeKey, _darkTheme);
    _prefs.then(
        (SharedPreferences prefs) => prefs.setBool(_themeKey, _darkTheme));
  }

  Future<void> getThemeSharedPref() async {
    final SharedPreferences prefs = await _prefs;
    _prefs.then(
        (SharedPreferences prefs) => {_darkTheme = prefs.getBool(_themeKey)!});
    // _darkTheme = prefs.getBool(_themeKey) ??
    //     false; // If theme key doesn't exist return false
    notifyListeners();
  }

  toggleTheme(bool value) {
    _darkTheme = value;
    setThemeSharedPref();
    notifyListeners(); // Calls all listeners to update their state
  }

  bool get darkTheme => _darkTheme;
}
