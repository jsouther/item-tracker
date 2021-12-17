import 'package:flutter/material.dart';
import 'package:journal/main.dart';

class ScaffoldWithDrawer extends StatelessWidget {

  final title;
  final body;
  final floatingActionButton;
  ScaffoldWithDrawer({this.title, this.body, this.floatingActionButton});
  

  @override
  Widget build(BuildContext context) {

    MyAppState appState = context.findAncestorStateOfType<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      endDrawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 60,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.color
                ),
                child: Text('Settings'),
              ),
            ),
            DarkModeToggle(updateTheme: appState.updateTheme),
          ]
        )
      )
    );
  }
}

class DarkModeToggle extends StatelessWidget {
  final void Function(bool) updateTheme;
  DarkModeToggle({this.updateTheme});

  @override
  Widget build(BuildContext context) {

  MyAppState appState = context.findAncestorStateOfType<MyAppState>();

    return SwitchListTile(
      title: Text('Dark Mode'),
      value: appState.widget.preferences.getBool(THEME_KEY) ?? false,
      onChanged: updateTheme
    );
  }
}