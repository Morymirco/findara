import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Guide',
                style: TextStyle(
                  color: Color.fromRGBO(163, 174, 190, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Processus d\'incubation',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                )
              ),
            ],
          ),
          bottom: TabBar(
            labelColor: Color.fromARGB(255, 79, 1, 1).withBlue(54),
            unselectedLabelColor: Color.fromRGBO(163, 174, 190, 1),
            tabs: [
              Tab(text: 'Poulet'),
              Tab(text: 'Canard'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPouletGuide(),
            _buildCanardGuide(),
          ],
        ),
      ),
    );
  }

  Widget _buildPouletGuide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Préparation (Jour 1)', [
            'Température: 37.5°C - 38.5°C',
            'Humidité: 50-60%',
            'Nettoyer et désinfecter l\'incubateur',
            'Placer les œufs pointe vers le bas',
          ], Colors.blue),
          _buildSection('Phase 1 (Jours 1-7)', [
            'Retourner les œufs 3-4 fois par jour',
            'Maintenir la température constante',
            'Vérifier l\'humidité quotidiennement',
            'Ne pas ouvrir l\'incubateur inutilement',
          ], Colors.green),
          _buildSection('Phase 2 (Jours 8-14)', [
            'Continuer le retournement régulier',
            'Mirer les œufs au 10e jour',
            'Retirer les œufs non fécondés',
            'Maintenir les conditions stables',
          ], Colors.orange),
          _buildSection('Phase finale (Jours 15-21)', [
            'Augmenter l\'humidité à 65-70% au jour 18',
            'Arrêter le retournement au jour 18',
            'Préparer l\'éclosion',
            'Ne plus ouvrir l\'incubateur',
          ], Colors.red),
          _buildSection('Éclosion (Jour 21)', [
            'L\'éclosion peut durer 24-48 heures',
            'Maintenir l\'humidité élevée',
            'Ne pas aider les poussins à sortir',
            'Laisser sécher avant de les déplacer',
          ], Colors.purple),
        ],
      ),
    );
  }

  Widget _buildCanardGuide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Préparation (Jour 1)', [
            'Température: 37.5°C - 38.0°C',
            'Humidité: 55-65%',
            'Nettoyer et désinfecter l\'incubateur',
            'Placer les œufs horizontalement',
          ], Colors.blue),
          _buildSection('Phase 1 (Jours 1-9)', [
            'Retourner les œufs 6 fois par jour',
            'Maintenir la température stable',
            'Vérifier l\'humidité deux fois par jour',
            'Refroidir les œufs 15 min par jour',
          ], Colors.green),
          _buildSection('Phase 2 (Jours 10-20)', [
            'Continuer le retournement régulier',
            'Mirer les œufs au 14e jour',
            'Retirer les œufs non fécondés',
            'Maintenir le refroidissement quotidien',
          ], Colors.orange),
          _buildSection('Phase finale (Jours 21-28)', [
            'Augmenter l\'humidité à 75-80% au jour 25',
            'Arrêter le retournement au jour 25',
            'Préparer l\'éclosion',
            'Arrêter le refroidissement',
          ], Colors.red),
          _buildSection('Éclosion (Jour 28)', [
            'L\'éclosion peut durer 24-48 heures',
            'Maintenir l\'humidité élevée',
            'Ne pas intervenir dans l\'éclosion',
            'Laisser sécher avant de les déplacer',
          ], Colors.purple),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color.fromRGBO(205, 213, 223, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.check_circle, color: color),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(76, 85, 102, 1),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_right,
                  color: color,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(76, 85, 102, 1),
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}
