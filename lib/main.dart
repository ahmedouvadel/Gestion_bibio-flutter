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
        // Couleur principale
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white, // Arrière-plan

        // Barre d'application
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),

        // Thème des boutons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),

        // Thème des champs de texte
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200], // Arrière-plan clair
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Colors.grey),
        ),

        // Thème des textes
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          titleLarge: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),

        // Effet sur les cartes
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Effet sur les ListTile
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.green,
          textColor: Colors.black,
        ),

        // Thème des icônes
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),

        // Thème des barres de navigation inférieures
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
