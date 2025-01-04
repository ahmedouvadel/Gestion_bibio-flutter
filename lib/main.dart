import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gestion_bibliotheque/screens/ecrivains_screen.dart';
import 'package:gestion_bibliotheque/screens/Acc_screen.dart';
import 'package:gestion_bibliotheque/screens/home_screen.dart';
import 'package:gestion_bibliotheque/screens/livres_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('Firebase initialisé avec succès!');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Bibliothèque',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
