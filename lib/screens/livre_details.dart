import 'dart:io';

import 'package:flutter/material.dart';

import '../models/livre.dart';

class LivreDetailsScreen extends StatelessWidget {
  final Livre livre;

  const LivreDetailsScreen({Key? key, required this.livre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(livre.titre)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(File(livre.photo), width: 100, height: 100),
            const SizedBox(height: 16),
            Text('Titre: ${livre.titre}', style: const TextStyle(fontSize: 18)),
            Text('ISBN: ${livre.isbn}', style: const TextStyle(fontSize: 18)),
            Text('Date de Sortie: ${livre.dateSortie}',
                style: const TextStyle(fontSize: 18)),
            Text('ID Écrivain: ${livre.ecrivainId}',
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
