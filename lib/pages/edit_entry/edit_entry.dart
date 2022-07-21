// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nap_app/models/journal.dart';
import 'package:nap_app/services/journal_edit.dart';

class EditEntry extends StatefulWidget {
  const EditEntry({
    Key? key,
    required this.add,
    required this.index,
    required this.journalEdit,
  }) : super(key: key);
  final bool add;
  final int index;
  final JournalEdit journalEdit;

  @override
  State<EditEntry> createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  late JournalEdit _journalEdit;
  late String _title;
  late DateTime _selectedDate;
  late TextEditingController _moodController;
  late TextEditingController _noteController;
  final FocusNode _moodFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _moodController = TextEditingController();
    _noteController = TextEditingController();
    _journalEdit =
        JournalEdit(action: 'Cancel', journal: widget.journalEdit.journal);
    _title = widget.add ? 'Add' : 'Edit';
    _journalEdit.journal = widget.journalEdit.journal;
    if (widget.add) {
      _selectedDate = DateTime.now();
      _moodController.text = '';
      _noteController.text = '';
    } else {
      _selectedDate = DateTime.parse(_journalEdit.journal.date);
      _moodController.text = _journalEdit.journal.mood;
      _noteController.text = _journalEdit.journal.note;
    }
  }

  @override
  void dispose() {
    _moodController.dispose();
    _noteController.dispose();
    _noteFocus.dispose();
    _moodFocus.dispose();
    super.dispose();
  }

  Future<DateTime> _selectDate(DateTime selectedDate) async {
    DateTime _initialDate = selectedDate;
    final DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime(DateTime.now().year.toInt() + 100),
    );
    if (_pickedDate != null) {
      selectedDate = DateTime(
        _pickedDate.year,
        _pickedDate.month,
        _pickedDate.day,
        _initialDate.hour,
        _initialDate.minute,
        _initialDate.second,
        _initialDate.millisecond,
        _initialDate.microsecond,
      );
    }

    return selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Entry"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(DateFormat.yMMMEd().format(_selectedDate)),
                  IconButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime _pickerDate = await _selectDate(_selectedDate);
                      setState(() {
                        _selectedDate = _pickerDate;
                      });
                    },
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _moodController,
                focusNode: _moodFocus,
                autofocus: true,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: "mood...",
                  icon: Icon(Icons.mood),
                ),
                onSubmitted: (submitted) {
                  FocusScope.of(context).requestFocus(_noteFocus);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _noteController,
                focusNode: _noteFocus,
                autofocus: true,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: "note...",
                  icon: Icon(Icons.subject),
                ),
                maxLines: null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _journalEdit.action = 'Save';
                      String _id = widget.add
                          ? Random().nextInt(9999999).toString()
                          : _journalEdit.journal.id;
                      _journalEdit.journal = Journal(
                        id: _id,
                        date: _selectedDate.toString(),
                        mood: _moodController.text,
                        note: _noteController.text,
                      );
                      Navigator.pop(context, _journalEdit);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.green.shade100),
                    ),
                    child: const Text("Save"),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      _journalEdit.action = "Cancel";
                      Navigator.pop(context, _journalEdit);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey.shade100),
                    ),
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
