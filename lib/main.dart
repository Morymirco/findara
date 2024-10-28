import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart'; // N'oubliez pas d'ajouter cette dépendance dans pubspec.yaml

import 'custom_dialog.dart';
import 'dashboard_page.dart';
// Suppression de l'import de Hive
// import 'package:hive_flutter/hive_flutter.dart';

import 'journaux.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSharedPreferences(); // Ajout de cette ligne
  runApp(const MyAppWrapper());
}

// Ajout de cette fonction
Future<void> initSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  // Vérifier si c'est le premier lancement
  if (prefs.getBool('isFirstLaunch') ?? true) {
    await prefs.clear(); // Nettoyer toutes les anciennes données
    await prefs.setBool('isFirstLaunch', false);
  }
}






class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinDara',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinDara',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const InitialPage(),
    );
  }
}

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPreviousData();
    });
  }

  Future<void> _checkPreviousData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? typeOeuf = prefs.getString('typeOeuf');
      final String? dateAjout = prefs.getString('dateAjout');

      if (!mounted) return;

      if (typeOeuf != null && dateAjout != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DashboardPage(
              typeOeuf: typeOeuf,
              dateAjout: DateTime.parse(dateAjout),
            ),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PageNotification()),
        );
      }
    } catch (e) {
      print('Erreur lors de la vérification des données: $e');
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PageNotification()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class PageNotification extends StatefulWidget {
  const PageNotification({super.key});

  @override
  State<PageNotification> createState() => _PageNotificationState();
}

class _PageNotificationState extends State<PageNotification> with JournalMixin {
  String? _selectedTypeOeuf;
  final TextEditingController _nombreOeufController = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final List<String> _typesOeuf = ['Poulet', 'Canard'];

  @override
  void initState() {
    super.initState();
    _initialiserNotifications();
  }

  Future<void> _initialiserNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _envoyerNotification() async {
    if (_selectedTypeOeuf == null || _nombreOeufController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    String message = 'Nouvel œuf ajouté:\n'
        'Type: ${_selectedTypeOeuf}\n'
        'Nombre: ${_nombreOeufController.text}\n'
        'Date de ponte: ${DateTime.now().toString()}';

    // Envoyer la notification locale
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'votre_canal_id',
      'Nom du Canal',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Nouvel œuf ajouté',
      message,
      platformChannelSpecifics,
    );

    // Sauvegarder la notification dans SharedPreferences et ajouter une entrée au journal
    await addJournalEntry(message);

    // Sauvegarder les données pour la prochaine utilisation
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('typeOeuf', _selectedTypeOeuf!);
    await prefs.setString('dateAjout', DateTime.now().toIso8601String());

    // Afficher la boîte de dialogue personnalisée
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Félicitations !',
          message: 'Les œufs ont été ajoutés avec succès.',
          onOkPressed: () {
            Navigator.of(context).pop(); // Fermer le dialogue
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => DashboardPage(
                  typeOeuf: _selectedTypeOeuf!,
                  dateAjout: DateTime.now(),
                ),
              ),
            );
          },
        );
      },
    );

    // Réinitialiser les champs après l'envoi
    setState(() {
      // _selectedTypeOeuf = null;
      _nombreOeufController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FINDARA',style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 79, 1, 1),
      ),
      body: Container(
        color: const Color.fromARGB(255, 79, 1, 1),
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                         AppBar().preferredSize.height -
                         MediaQuery.of(context).padding.top -
                         MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset('images/findaara_logo.png', height: 150,
                      fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      _buildDropdownField('Type d\'oeuf', _typesOeuf, _selectedTypeOeuf, (value) {
                        setState(() {
                          _selectedTypeOeuf = value;
                        });
                      }, 'Donner le type d\'oeuf'),
                      _buildNumberField('Nombre d\'œuf', _nombreOeufController, 'Entrer le nombre d\'œufs'),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _envoyerNotification,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            backgroundColor: const Color.fromARGB(255, 131, 73, 1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Ajouter',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String? selectedValue, Function(String?) onChanged, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      value.toLowerCase() == 'poulet' 
                        ? 'assets/icons/chicken.svg'
                        : 'assets/icons/duck.svg',
                      width: 24,
                      height: 24,
                      color: Color.fromARGB(255, 79, 1, 1),
                    ),
                    SizedBox(width: 10),
                    Text(value),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}






