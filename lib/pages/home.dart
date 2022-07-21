import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nap_app/models/journal.dart';
import 'package:nap_app/models/database.dart';
import 'package:nap_app/pages/edit_entry/edit_entry.dart';
import 'package:nap_app/services/database_file_path.dart';
import 'package:nap_app/services/journal_edit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Database _database;

  Future<List<Journal>> _loadDatabase() async {
    await DatabaseFileRoutines().readJournals().then((journalsJson) {
      //get database in
      _database = toDatabaseStrToObjJson(journalsJson);
      _database.journals
          .sort((comp1, comp2) => comp2.date.compareTo(comp1.date));
    });
    return _database.journals;
  }

  void _addOrEditJournal(
      {required bool add, required int index, required Journal journal}) async {
    JournalEdit journalEdit = JournalEdit(action: '', journal: journal);
    journalEdit = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEntry(
          add: add,
          index: index,
          journalEdit: journalEdit,
        ),
        fullscreenDialog: true,
      ),
    );
    switch (journalEdit.action) {
      case 'Save':
        if (add) {
          setState(() {
            _database.journals.add(journalEdit.journal);
          });
        } else {
          setState(() {
            _database.journals[index] = journalEdit.journal;
          });
        }
        DatabaseFileRoutines()
            .writeJournals(fromDatabaseObjToStrJson(_database));
        break;
      case 'Cancel':
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal"),
      ),
      body: FutureBuilder(
        initialData: const [],
        future: _loadDatabase(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? const CircularProgressIndicator()
              : ListView.separated(
                  itemBuilder: (context, index) {
                    String titleDate = DateFormat.yMMMd().format(
                      DateTime.parse(snapshot.data[index].date),
                    );
                    String subtitle = snapshot.data[index].mood +
                        "\n" +
                        snapshot.data[index].note;
                    return Dismissible(
                      key: Key(snapshot.data[index].id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 16.0),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16.0),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: ListTile(
                        leading: Column(
                          children: <Widget>[
                            Text(
                              DateFormat.d().format(
                                  DateTime.parse(snapshot.data[index].date)),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32.0,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              DateFormat.E().format(
                                DateTime.parse(snapshot.data[index].date),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          titleDate,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(subtitle),
                        onTap: () {
                          _addOrEditJournal(
                            add: false,
                            index: index,
                            journal: snapshot.data[index],
                          );
                        },
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          _database.journals.removeAt(index);
                        });
                        DatabaseFileRoutines()
                            .writeJournals(fromDatabaseObjToStrJson(_database));
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.grey,
                    );
                  },
                  itemCount: snapshot.data.length,
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addOrEditJournal(
              add: true,
              index: -1,
              journal: Journal(date: '', id: '', mood: '', note: ''));
        },
        tooltip: "Add journal Entry",
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.all(24),
        ),
      ),
    );
  }
}
