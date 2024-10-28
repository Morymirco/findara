import 'package:findara/widgets/statisticsTile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
 // Ajoutez cet import


import 'journaux.dart';
import 'main.dart'; // Assurez-vous que ce fichier contient la classe PageNotification
import 'tutorial_page.dart';

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

  String _formatDateEnFrancais() {
    DateTime maintenant = DateTime.now();
    List<String> joursSemaine = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
    List<String> mois = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
      'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    
    String jour = joursSemaine[maintenant.weekday % 7];
    String moisStr = mois[maintenant.month - 1];
    return '$jour, ${maintenant.day} $moisStr';
  }

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
                "Aujourd'hui",
                style: TextStyle(
                  color: Color.fromRGBO(163, 174, 190, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 7),
            Text(
                      _formatDateEnFrancais(),
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
                color: Color.fromARGB(163, 211, 126, 23).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15)
              ),
              child: IconButton(
                icon: Icon(Icons.help_outline),
                color: Color.fromARGB(255, 146, 20, 11),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TutorialPage()),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Color.fromARGB(163, 211, 126, 23).withOpacity(0.1),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressChart(),
          const SizedBox(height: 16),
          // Remplacer le GridView par une Column
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard('Température', _getTemperature(), Icons.thermostat, Colors.red),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard('Humidité', _getHumidite(), Icons.water_drop, Colors.green),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard('Durée\nd\'incubation', _getDureeIncubation(), Icons.timer, Colors.orange),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard('Fréquence\nde retour', _getFrequenceRetournement(), Icons.rotate_right, Colors.lightBlue),
                  ),
                ],
              ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Progression de l'incubation",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 7),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.typeOeuf.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              _circleProgress(joursEcoules, joursTotal),
              const SizedBox(height: 26),
              Text(
                textAlign: TextAlign.center,
                "$joursRestants jours restants sur $joursTotal",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AJOUT 

   Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      child: statisticsTile(
        title: title,
        icon: Icon(
          icon,
          color: color,
          size: 32.0,
        ),
        value: value,
        progressColor: color,
        progressPercent: 0.4,
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
    bool confirmReset = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 79, 1, 1).withBlue(54).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Color.fromARGB(255, 79, 1, 1).withBlue(54),
                    size: 32,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Réinitialiser l\'application',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(76, 85, 102, 1),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Êtes-vous sûr de vouloir réinitialiser l\'application ? Toutes les données seront effacées.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(163, 174, 190, 1),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'Annuler',
                        style: TextStyle(
                          color: Color.fromRGBO(163, 174, 190, 1),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 79, 1, 1).withBlue(54),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Réinitialiser',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmReset == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
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



