import 'package:flutter/material.dart';

import '../auth/calsync_auth.dart';
import '../settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Center(child: CalsyncAuth()),
          ),
          Settings(),
        ],
      ),
    );
  }
}
