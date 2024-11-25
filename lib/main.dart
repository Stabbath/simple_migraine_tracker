import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'entry_model.dart';
import 'new_entry_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Migraine Log',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final String fileName = 'migraine_log.json';
  Map<DateTime, Entry> _migraineLog = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    if (await file.exists()) {
      final data = await file.readAsString();
      setState(() {
        _migraineLog = (json.decode(data) as Map<String, dynamic>).map(
          (key, value) => MapEntry(DateTime.parse(key), Entry.fromJson(value)),
        );
      });
    }
  }

  Future<void> _saveData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    final data = json.encode(_migraineLog.map((key, value) => MapEntry(key.toIso8601String(), value.toJson())));
    await file.writeAsString(data);
  }

  Widget calendarDateBuilder(context, DateTime date, DateTime focusedDate) {
    if (_migraineLog.containsKey(date)) {
      Entry entry = _migraineLog[date]!;
      String content = '''
        ${entry.migraine}
        Alcohol: ${entry.alcohol}
        ${entry.stressLevel.isNotEmpty ? 'Stress: ${entry.stressLevel}' : ''}
      '''.split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .join('\n');
      
      if (entry.shortNote.isNotEmpty) {
          content += '\nShort: ${entry.shortNote}';
      }
      
      if (entry.longNote.isNotEmpty && _calendarFormat == CalendarFormat.week) {
        content += '\nLong: ${entry.longNote}';
      }
      
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: date.day == DateTime.now().day && date.month == DateTime.now().month && date.year == DateTime.now().year ? Colors.purple[100] : null,
            borderRadius: BorderRadius.circular(100),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(date.day.toString()),
            ),
          ),
          Material(
            color: entry.migraine == 'Migraine' ? Colors.red[100]
              : entry.migraine == 'Headache' ? Colors.orange[100]
              : Colors.green[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    content,
                    maxLines: _calendarFormat == CalendarFormat.week ? 15
                      : _calendarFormat == CalendarFormat.twoWeeks ? 12
                      : 5,
                    style: const TextStyle(fontSize: 8),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (entry.longNote.isNotEmpty && _calendarFormat == CalendarFormat.week)
                    Text(
                      'Long: ${entry.longNote}',
                      style: const TextStyle(fontSize: 8),
                      maxLines: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: date.day == DateTime.now().day && date.month == DateTime.now().month && date.year == DateTime.now().year ? Colors.purple[100] : null,
            borderRadius: BorderRadius.circular(100),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(date.day.toString()),
            ),
          ),
          Material(
            color: Colors.lightBlue[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('No Entry', style: TextStyle(fontSize: 8)),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Migraine Log'),
      ),
      body: TableCalendar(
        shouldFillViewport: true,
        onDaySelected: (selectedDay, focusedDay) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewEntryPage(_migraineLog, selectedDay)),
          ).then((_) {
            setState(() {
              _focusedDay = focusedDay;
            }); // Refresh the UI
            _saveData();
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        calendarFormat: _calendarFormat,
        calendarBuilders: CalendarBuilders(
          todayBuilder: calendarDateBuilder,
          defaultBuilder: calendarDateBuilder,
          dowBuilder: (context, day) {
            return Center(
              child: Text(
                day.weekday == DateTime.sunday ? 'Sun'
                  : day.weekday == DateTime.monday ? 'Mon'
                  : day.weekday == DateTime.tuesday ? 'Tue'
                  : day.weekday == DateTime.wednesday ? 'Wed'
                  : day.weekday == DateTime.thursday ? 'Thu'
                  : day.weekday == DateTime.friday ? 'Fri'
                  : 'Sat',
                style: const TextStyle(
                  color: Color.fromARGB(255, 158, 37, 138),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
