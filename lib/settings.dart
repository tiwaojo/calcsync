import 'package:calendar_sync/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    bool _autofocus = false;
    return Column(
      children: <Widget>[
        Consumer<CalsyncThemeNotification>(builder: (context, notifier, child) {
          return SwitchListTile(
            value: notifier.darkTheme,
            title: Text(
              notifier.darkTheme ? "Dark Theme" : "Light Theme",
              style: Theme.of(context).textTheme.headline5,
            ),
            onChanged: (bool value) {
              // notifier.toggleTheme(value);
              setState(() {
                notifier.toggleTheme(value);
                // print(notifier.toggleTheme(value));
                print("Value of theme: $value");
              });
            },
          );
        }),
        // SwitchListTile(
        //   value: _autofocus,
        //   secondary: Icon(Icons.center_focus_weak_rounded),
        //   subtitle: Text("Enable auto focus of text"),
        //   // controlAffinity: ListTileControlAffinity.platform,
        //   onChanged: (value) {
        //     setState(() {
        //       _autofocus = value;
        //       print(value);
        //       print("Autofocus: $_autofocus");
        //     });
        //   },
        //   title: Text(
        //     "AutoFocus TextField",
        //     style: Theme.of(context).textTheme.headline5,
        //   ),
        // )
      ],
    );
  }
}
