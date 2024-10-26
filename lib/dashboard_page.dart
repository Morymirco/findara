import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'journaux.dart';

class DashboardPage extends StatefulWidget {
  final String typeOeuf;
  final DateTime dateAjout;

  const DashboardPage({Key? key, required this.typeOeuf, required this.dateAjout}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with JournalMixin {
  late int joursRestants;
  late int joursTotal;
  late int joursEcoules;

  @override
  void initState() {
    super.initState();
    calculerJoursRestants();
  }

  void calculerJoursRestants() {
    joursTotal = widget.typeOeuf.toLowerCase() == 'poulet' ? 21 : 28;
    joursEcoules = DateTime.now().difference(widget.dateAjout).inDays;
    joursRestants = joursTotal - joursEcoules;
    if (joursRestants < 0) joursRestants = 0;
    if (joursEcoules > joursTotal) joursEcoules = joursTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard - ${widget.typeOeuf}'),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 79, 1, 1),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard('Température', _getTemperature(), Icons.thermostat),
                const SizedBox(height: 16),
                _buildInfoCard('Humidité', _getHumidite(), Icons.water_drop),
                const SizedBox(height: 16),
                _buildInfoCard('Durée d\'incubation', _getDureeIncubation(), Icons.timer),
                const SizedBox(height: 16),
                _buildInfoCard('Fréquence de retournement', _getFrequenceRetournement(), Icons.rotate_right),
                const SizedBox(height: 16),
                _buildProgressChart(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToJournalPage(context),
        child: const Icon(Icons.list),
        backgroundColor: Colors.brown,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildProgressChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Progression de l'incubation",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150, // Réduction de la hauteur du diagramme
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 30, // Réduction du rayon de l'espace central
                  sections: [
                    PieChartSectionData(
                      color: Colors.yellow, // Changement de la couleur en jaune
                      value: joursEcoules.toDouble(),
                      title: '${(joursEcoules / joursTotal * 100).toStringAsFixed(1)}%',
                      radius: 75, // Réduction du rayon des sections
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Changement de la couleur du texte pour une meilleure lisibilité
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.grey,
                      value: joursRestants.toDouble(),
                      title: '${(joursRestants / joursTotal * 100).toStringAsFixed(1)}%',
                      radius: 75, // Réduction du rayon des sections
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                swapAnimationDuration: const Duration(milliseconds: 150),
                swapAnimationCurve: Curves.linear,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "$joursRestants jours restants sur $joursTotal",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.brown),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTemperature() {
    switch (widget.typeOeuf.toLowerCase()) {
      case 'poulet':
        return '37.5°C - 38.5°C';
      case 'canard':
        return '37.5°C - 38.0°C';
      default:
        return 'Non spécifié';
    }
  }

  String _getHumidite() {
    switch (widget.typeOeuf.toLowerCase()) {
      case 'poulet':
        return '50% - 60%';
      case 'canard':
        return '55% - 65%';
      default:
        return 'Non spécifié';
    }
  }

  String _getDureeIncubation() {
    switch (widget.typeOeuf.toLowerCase()) {
      case 'poulet':
        return '21 jours';
      case 'canard':
        return '28 jours';
      default:
        return 'Non spécifié';
    }
  }

  String _getFrequenceRetournement() {
    switch (widget.typeOeuf.toLowerCase()) {
      case 'poulet':
        return 'Toutes les 3-4 heures';
      case 'canard':
        return 'Toutes les 6 heures';
      default:
        return 'Non spécifié';
    }
  }
}
