// Importer les packages nécessaires
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
    print('Loaded ${journalEntries.length} entries'); // Debug log
  }

  Future<void> addJournalEntry(String message) async {
    final entry = JournalEntry(message, DateTime.now());
    journalEntries.add(entry);
    await _saveJournalEntries();
    setState(() {}); // Trigger UI update
    print('Added new entry. Total entries: ${journalEntries.length}'); // Debug log
  }

  Future<void> _saveJournalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedEntries = jsonEncode(journalEntries.map((e) => e.toJson()).toList());
    await prefs.setString('journal_entries', encodedEntries);
    print('Saved entries to SharedPreferences'); // Debug log
  }

  void navigateToJournalPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JournalPage(entries: journalEntries)),
    );
  }
}

// Page pour afficher les journaux
class JournalPage extends StatelessWidget {
  final List<JournalEntry> entries;

  const JournalPage({Key? key, required this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journaux des notifications'),
      ),
      body: entries.isEmpty
          ? Center(child: Text('Aucune entrée de journal',style: TextStyle(color: Color.fromARGB(255, 79, 1, 1).withBlue(54),),))
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[entries.length - 1 - index];
                return Dismissible(
                  background: Container(
                    child: Icon(Icons.delete,color: Colors.white,),
                    color: Color.fromARGB(255, 79, 1, 1).withBlue(54),
                  ),
                  key: Key(entries[index].toString()),
                  onDismissed: (direction){
                    entries.removeAt(index);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.add_circle, color: Colors.green),
                    title: const Text('Nouvel Ajout'),
                    subtitle: Text(entry.message),
                    trailing: Text(
                      _formatTime(entry.timestamp),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
