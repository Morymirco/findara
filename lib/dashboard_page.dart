import 'package:findara/widgets/statisticsTile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'journaux.dart';
import 'main.dart'; // Assurez-vous que ce fichier contient la classe PageNotification

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
        // title: Text('Dashboard - ${widget.typeOeuf}'),
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Text(
                'Today',
                style: TextStyle(
                  color:  Color.fromRGBO(163, 174, 190, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 7),
            Text(
                      'Wed, 18 Aug',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      )),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
               height: 45,
              width: 45,
              decoration: BoxDecoration(
                color:  Color.fromARGB(163, 211, 126, 23).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15)
              ),
              child: IconButton(
                color: const Color.fromARGB(255, 146, 20, 11),
                icon: const Icon(Icons.delete),
                onPressed: () => _resetApplication(context),
              ),
            ),
          ),
        ],
      ),
      body: Container(
  width: double.infinity,
  color: Colors.white,
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProgressChart(),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildInfoCard('Température', _getTemperature(), Icons.thermostat, Colors.red),
              _buildInfoCard('Humidité', _getHumidite(), Icons.water_drop, Colors.green),
              _buildInfoCard('Durée \n d\'incubation', _getDureeIncubation(), Icons.timer, Colors.orange),
              _buildInfoCard('Fréquence \n de retour', _getFrequenceRetournement(), Icons.rotate_right, Colors.lightBlue),
            ],
          ),
        ],
      ),
    ),
  ),
),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToJournalPage(context),
        child: const Icon(Icons.list,color: Colors.white ,),
        backgroundColor: Color.fromARGB(255, 79, 1, 1).withBlue(54),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildProgressChart() {
    return Container(
    
      width: double.infinity,
      child: Card(
     color: const Color.fromARGB(255, 79, 1, 1).withBlue(54),   
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Progression de l'incubation",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 26),
                 _circleProgress(joursEcoules,joursTotal),
              // SizedBox(
              //   height: 250, // Réduction de la hauteur du diagramme
              //   child: PieChart(
              //     PieChartData(
              //       sectionsSpace: 0,
              //       centerSpaceRadius: 60, // Réduction du rayon de l'espace central
              //       sections: [
              //         PieChartSectionData(
              //           color: Colors.yellow, // Changement de la couleur en jaune
              //           value: joursEcoules.toDouble(),
              //           title: '${(joursEcoules / joursTotal * 100).toStringAsFixed(1)}%',
              //           radius: 75, // Réduction du rayon des sections
              //           titleStyle: const TextStyle(
              //             fontSize: 14,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.black, // Changement de la couleur du texte pour une meilleure lisibilité
              //           ),
              //         ),
              //         PieChartSectionData(
              //           color: Color.fromARGB(164, 131, 73, 1),
              //           value: joursRestants.toDouble(),
              //           title: '${(joursRestants / joursTotal * 100).toStringAsFixed(1)}%',
              //           radius: 75, // Réduction du rayon des sections
              //           titleStyle: const TextStyle(
              //             fontSize: 14,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ],
              //     ),
              //     swapAnimationDuration: const Duration(milliseconds: 150),
              //     swapAnimationCurve: Curves.linear,
              //   ),
              // ),
              const SizedBox(height: 26),
              Text(
                textAlign: TextAlign.center,
                "$joursRestants jours restants sur $joursTotal",
                style: const TextStyle(fontSize: 16,color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AJOUT 

  Widget _buildInfoCard(String title, String value, IconData icon,Color color) {
    return   Container(
      margin: EdgeInsets.only(top: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          statisticsTile(
            title: title,
            icon: Icon(
              icon,
              color: color,
              size: 32.0,
            ),
            progressColor: Color.fromRGBO(76, 85, 102, 1),
            value:value,
            progressPercent: 0.4
          ),
          
        ],
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
        return 'Toutes les 3-4 h';
      case 'canard':
        return 'Toutes les 6 h';
      default:
        return 'Non spécifié';
    }
  }

  Future<void> _resetApplication(BuildContext context) async {
    // Afficher une boîte de dialogue de confirmation
    bool confirmReset = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Réinitialiser l\'application'),
          content: const Text('Êtes-vous sûr de vouloir réinitialiser l\'application ? Toutes les données seront effacées.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Réinitialiser'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmReset == true) {
      // Réinitialiser les SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Rediriger vers la page d'ajout
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const PageNotification()),
        (Route<dynamic> route) => false,
      );
    }
  }
}





  Widget _circleProgress(joursEcoules,joursTotal) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        children: [
          SizedBox(
            width: 160 ,
            height: 160 ,
            child: CircularProgressIndicator(
              strokeWidth: 8 ,
              value: 0.7,
              backgroundColor:Color.fromRGBO(248, 250, 252, 1).withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation < Color > (Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.all(13),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color:Color.fromRGBO(248, 250, 252, 1).withOpacity(0.2), width: 8),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(248, 250, 252, 1).withOpacity(0.1),
                ),
                child: Container(
                  margin: EdgeInsets.all(22),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Evolution',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${(joursEcoules / joursTotal * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          color:Color.fromARGB(163, 211, 126, 23),
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        'en pourcentage',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
