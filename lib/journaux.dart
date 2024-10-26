// Importer les packages nécessaires
import 'package:flutter/material.dart';
// Suppression des imports de Hive
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// Suppression de la partie générée
// part 'journaux.g.dart';

// Classe pour représenter une entrée de journal
// Suppression des annotations Hive
class JournalEntry {
  String message;
  DateTime timestamp;

  JournalEntry(this.message, this.timestamp);
}

// Mixin pour ajouter la fonctionnalité de journal
mixin JournalMixin<T extends StatefulWidget> on State<T> {
  // Suppression de la référence à Box
  // late Box<JournalEntry> _journalBox;
  List<JournalEntry> journalEntries = [];

  @override
  void initState() {
    super.initState();
    // Suppression de l'initialisation de Hive
    // _initHive();
    _loadJournalEntries();
  }

  // Suppression de la méthode _initHive

  void _loadJournalEntries() {
    // Cette méthode devra être modifiée pour charger les entrées depuis une nouvelle source de données
    // Pour l'instant, nous la laissons vide
    setState(() {
      // journalEntries = _journalBox.values.toList();
    });
  }

  Future<void> addJournalEntry(String message) async {
    final entry = JournalEntry(message, DateTime.now());
    // Cette méthode devra être modifiée pour sauvegarder l'entrée dans une nouvelle source de données
    // Pour l'instant, nous l'ajoutons simplement à la liste en mémoire
    setState(() {
      journalEntries.add(entry);
    });
    // await _journalBox.add(entry);
    // _loadJournalEntries();
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
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[entries.length - 1 - index];
          return ListTile(
            leading: const Icon(Icons.add_circle, color: Colors.green),
            title: const Text('Nouvel Ajout'),
            subtitle: Text(entry.message),
            trailing: Text(
              _formatTime(entry.timestamp),
              style: const TextStyle(fontSize: 12),
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
