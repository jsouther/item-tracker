import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:journal/screens/detail_view.dart';
import 'package:journal/screens/main_screen.dart';
import 'package:journal/screens/new_entry_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const THEME_KEY = 'darkMode';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp
  ]);
  runApp(MyApp(preferences: await SharedPreferences.getInstance()));
}

class MyApp extends StatefulWidget {

  final SharedPreferences preferences;
  MyApp({Key key, @required this.preferences}) : super(key: key);

  static final routes = {
    MainScreen.routeName: (context) => MainScreen(),
    NewEntryScreen.routeName: (context) => NewEntryScreen(),
    DetailView.routeName: (context) => DetailView()
  };

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  bool get themeSetting =>
    widget.preferences.getBool(THEME_KEY) ?? false;

  void initState() {
    super.initState();
  }

  void updateTheme(bool value) {
    setState(() {
      widget.preferences.setBool(THEME_KEY, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: setBrightness(themeSetting)
      ),
      routes: MyApp.routes,
    );
  }
}

Brightness setBrightness(bool darkMode) {
  if (darkMode) {
    return Brightness.dark;
  } else {
    return Brightness.light;
  }
}