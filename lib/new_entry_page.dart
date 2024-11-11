import 'package:flutter/material.dart';

import 'entry_model.dart';

class NewEntryPage extends StatefulWidget {
  final Map<DateTime, Entry> migraineLog;
  final DateTime selectedDate;

  const NewEntryPage(this.migraineLog, this.selectedDate, {super.key});

  @override
  NewEntryPageState createState() => NewEntryPageState();
}

class NewEntryPageState extends State<NewEntryPage> {
  bool _isNewEntry = true;
  String _hadMigraine = 'Headache';
  String _alcohol = 'No';
  final TextEditingController _stressLevelController = TextEditingController();
  final TextEditingController _shortNotesController = TextEditingController();
  final TextEditingController _longNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
      final entry = widget.migraineLog[widget.selectedDate];
      _hadMigraine = entry?.migraine ?? 'Headache';
      _alcohol = entry?.alcohol ?? 'No';
      _stressLevelController.text = entry?.stressLevel ?? '';
      _shortNotesController.text = entry?.shortNote ?? '';
      _longNotesController.text = entry?.longNote ?? '';
      _isNewEntry = entry == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('${_isNewEntry ? 'New Entry' : 'Edit Entry'}: '),
            const Icon(Icons.calendar_today),
            Text(' ${widget.selectedDate.toLocal().toString().split(' ')[0]}'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteEntry,
          )
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Migraine?'),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0), // Adjust the value as needed
                child: Row(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Headache',
                          groupValue: _hadMigraine,
                          onChanged: (String? value) {
                            setState(() {
                              _hadMigraine = value!;
                            });
                          },
                        ),
                        const Text('Headache'),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Migraine',
                          groupValue: _hadMigraine,
                          onChanged: (String? value) {
                            setState(() {
                              _hadMigraine = value!;
                            });
                          },
                        ),
                        const Text('Migraine'),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Fine',
                          groupValue: _hadMigraine,
                          onChanged: (String? value) {
                            setState(() {
                              _hadMigraine = value!;
                            });
                          },
                        ),
                        const Text('Fine'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Alcohol'),
              trailing: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _alcohol,
                    onChanged: (String? newValue) {
                      setState(() {
                        _alcohol = newValue!;
                      });
                    },
                    items: <String>[
                      'No',
                      'A little',
                      'Some',
                      'A lot',
                      'Too much',
                      'Way too much'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            TextField(
              controller: _stressLevelController,
              decoration: const InputDecoration(
                labelText: 'Stress',
                border: OutlineInputBorder(),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            TextField(
              controller: _shortNotesController,
              decoration: const InputDecoration(
                labelText: 'Short Notes',
                hintText: 'Short Notes - Some brief notes, which you will be able to see directly on the calendar.',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            TextField(
              controller: _longNotesController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Long Notes',
                hintText: 'Long Notes - If you need to write down more stuff. This will only be visible when you open the entry.',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveEntry,
                child: const Text('Save Entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveEntry() {
    widget.migraineLog[widget.selectedDate] = Entry(
      migraine: _hadMigraine,
      alcohol: _alcohol,
      stressLevel: _stressLevelController.text,
      shortNote: _shortNotesController.text,
      longNote: _longNotesController.text,
    );

    Navigator.pop(context);
  }

  void _deleteEntry() {
    widget.migraineLog.remove(widget.selectedDate);
    Navigator.pop(context);
  }
}