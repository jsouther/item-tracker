import 'package:flutter/material.dart';
import 'package:journal/components/scaffold_with_drawer.dart';
import 'package:journal/models/journal_entry.dart';

class DetailView extends StatelessWidget {

  static const routeName = 'detailView';
  final JournalEntry journalEntry;

  DetailView({this.journalEntry});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithDrawer(
      title: journalEntry.dateTime.toString(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              journalEntry.title,
              style: Theme.of(context).textTheme.headline2),
            SizedBox(height: 10),
            Text(journalEntry.body),
            SizedBox(height: 100),
            Text('Rating: ${journalEntry.rating.toString()}')
          ],
        ),
      ),
    );
  }
}