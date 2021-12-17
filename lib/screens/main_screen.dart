import 'package:flutter/material.dart';

import 'package:journal/components/scaffold_with_drawer.dart';
import 'package:journal/models/journal.dart';
import 'package:journal/models/journal_entry.dart';
import 'package:journal/screens/detail_view.dart';
import 'package:journal/screens/new_entry_screen.dart';
import 'package:sqflite/sqflite.dart';

class MainScreen extends StatefulWidget {

  static const routeName = '/';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Journal journal;

  @override
  void initState() {
    super.initState();
    loadJournal();
    setState(() {});
  }

  //From SQL exploration
  void loadJournal() async {
    final Database database = await openDatabase(
      'journal.db', version: 1, onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS journal_entries(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, body TEXT, rating INTEGER, date TEXT)');
      }
    );
    List<Map> journalRecords = await database.rawQuery('SELECT * FROM journal_entries');
    final journalEntries = journalRecords.map( (record) {
      return JournalEntry(
        title: record['title'],
        body: record['body'],
        rating: record['rating'],
        dateTime: DateTime.parse(record['date'])
      );
    }).toList();
    setState(() {
      journal = Journal(entries: journalEntries);
    });
  }


  Widget build(BuildContext context) {
    if (journal == null) {
      return ScaffoldWithDrawer(
        title: 'Loading',
        body: Center(
          child: CircularProgressIndicator(),
        )
      );
    } else {
    return ScaffoldWithDrawer(
      title: journal.length == 0 ? 'Journal' : 'Journal Entries',
      body: journal.length != 0 ? 
        ListView.builder(
          itemCount: journal.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${journal.entries[index].title}'),
              subtitle: Text('${journal.entries[index].dateTime}'),
              onTap: () => navigateToDetailView(context, journal.entries[index])  
            );
          }
        )
      :
        EmptyJournal(),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            pushNewEntryScreen(context);
          },
          child: Icon(Icons.add),
        )
    );
    }
  }

  void pushNewEntryScreen (BuildContext context) {
    Navigator.of(context).pushNamed(NewEntryScreen.routeName).then((value) {
      setState(() {
        loadJournal();
      });
    });
  }

  void navigateToDetailView(BuildContext context, JournalEntry journalEntry) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return DetailView(journalEntry: journalEntry);
      },
    ));
  }
}

class EmptyJournal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book, size: 150)
          ]
        )
      );
  }
}