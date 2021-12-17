import 'package:journal/models/journal_entry.dart';

class Journal {

  final List<JournalEntry> entries;

  Journal({this.entries});

  int get length {
    return entries.length;
  }
}