// Importer les packages nécessaires
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/statisticsTile.dart';


// Classe pour représenter une entrée de journal
class JournalEntry {
  String message;
  DateTime timestamp;

  JournalEntry(this.message, this.timestamp);

  Map<String, dynamic> toJson() => {
    'message': message,
    'timestamp': timestamp.toIso8601String(),
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    json['message'],
    DateTime.parse(json['timestamp']),
  );
}

// Mixin pour ajouter la fonctionnalité de journal
mixin JournalMixin<T extends StatefulWidget> on State<T> {
  List<JournalEntry> journalEntries = [];

  @override
  void initState() {
    super.initState();
    _loadJournalEntries();
  }

  Future<void> _loadJournalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? entriesJson = prefs.getString('journal_entries');
    if (entriesJson != null) {
      final List<dynamic> decodedEntries = jsonDecode(entriesJson);
      setState(() {
        journalEntries = decodedEntries.map((e) => JournalEntry.fromJson(e)).toList();
      });
    }
  }

  Future<void> addJournalEntry(String message) async {
    final entry = JournalEntry(message, DateTime.now());
    setState(() {
      journalEntries.add(entry);
    });
    await _saveJournalEntries();
  }

  Future<void> _saveJournalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedEntries = jsonEncode(journalEntries.map((e) => e.toJson()).toList());
    await prefs.setString('journal_entries', encodedEntries);
  }

  void navigateToJournalPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JournalPage(entries: journalEntries)),
    );
  }
}

// Page pour afficher les journaux
class JournalPage extends StatefulWidget {
  final List<JournalEntry> entries;

  const JournalPage({Key? key, required this.entries}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late List<JournalEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = widget.entries;
  }

  Future<void> _removeEntry(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _entries.removeAt(_entries.length - 1 - index);
    });
    final String encodedEntries = jsonEncode(_entries.map((e) => e.toJson()).toList());
    await prefs.setString('journal_entries', encodedEntries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journaux des notifications'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color:  Colors.white,
        child: _entries.isEmpty
          ? Center(
              child: Text(
                'Aucune entrée de journal',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[_entries.length - 1 - index];
                return Dismissible(
                  key: Key(entry.timestamp.toString()),
                  background: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    await _removeEntry(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notification supprimée')),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: notificationTile(
                      title: 'Nouvel Ajout',
                      icon: Icon(
                        Icons.notifications_active,
                        color: Colors.green,
                        size: 24.0,
                      ),
                      message: entry.message,
                      time: _formatTime(entry.timestamp),
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
