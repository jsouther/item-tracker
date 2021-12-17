import 'package:flutter/material.dart';
import 'package:journal/components/dropdown_rating_form_field.dart';
import 'package:journal/components/scaffold_with_drawer.dart';
import 'package:journal/components/spaced_textformfield.dart';
import 'package:journal/models/journal_entry_form_fields.dart';
import 'package:sqflite/sqflite.dart';

class NewEntryScreen extends StatefulWidget {

  static const routeName = 'newEntry';

  @override
  _NewEntryScreenState createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  @override
  Widget build(BuildContext context) {

    final formKey = GlobalKey<FormState>();
    final journalEntryFormFields = JournalEntryFormFields();

    void saveTitle(value) {
      journalEntryFormFields.title = value;
    }

    void saveBody(value) {
      journalEntryFormFields.body = value;
    }

    void saveRating(value) {
      journalEntryFormFields.rating = value;
    }

    String validateString(value) {
      if (value.isEmpty) {
        return 'Please enter something';
      } else {
        return null;
      }
    }

    String validateInt(value) {
      if (value == null) {
        return 'Please enter something';
      } else {
        return null;
      }
    }

    //From exploration: Managing Data With SQLite
    void addDateToJournalEntryValues() {
      journalEntryFormFields.dateTime = DateTime.now().toString();
    }

    return ScaffoldWithDrawer(title: 'New Entry Screen',
      body: Padding(
        padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SpacedTextFormField(text: 'Title', height: 10, onSaved: saveTitle, validator: validateString),
                  SpacedTextFormField(text: 'Body', height: 10, onSaved: saveBody, validator: validateString),
                  SizedBox(height: 10),
                  DropdownRatingFormField(maxRating: 4, onSaved: saveRating, validator: validateInt),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            addDateToJournalEntryValues();

                            //From SQL exploration
                            final Database database = await openDatabase(
                              'journal.db', version: 1, onCreate: (Database db, int version) async {
                                await db.execute(
                                  'CREATE TABLE IF NOT EXISTS journal_entries(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, body TEXT, rating INTEGER, date TEXT)');
                              }
                            );

                            //From SQL exploration
                            await database.transaction( (txn) async {
                              await txn.rawInsert('INSERT INTO journal_entries(title, body, rating, date) VALUES(?,?,?,?)',
                                [journalEntryFormFields.title, journalEntryFormFields.body, journalEntryFormFields.rating, journalEntryFormFields.dateTime]
                              );
                            });
                            
                            await database.close();

                            Navigator.pop(context);
                          }
                        },
                        child: Text('Save'),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
      ),
    );

  }
}