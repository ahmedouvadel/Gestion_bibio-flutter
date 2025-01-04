import 'dart:io';

import 'package:flutter/material.dart';

import '../models/livre.dart';

class LivreDetailsScreen extends StatelessWidget {
  final Livre livre;

  const LivreDetailsScreen({Key? key, required this.livre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          livre.titre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image avec effet arrondi et hauteur augmentée
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.file(
                  File(livre.photo),
                  width: double.infinity,
                  height:
                      300, // Hauteur augmentée pour mettre en valeur l'image
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Informations sur le livre
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      livre.titre,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ISBN
                    Row(
                      children: [
                        const Icon(Icons.code, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'ISBN: ${livre.isbn}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Date de sortie
                    Row(
                      children: [
                        const Icon(Icons.date_range, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Date de Sortie: ${livre.dateSortie}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // ID de l'écrivain
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'ID Écrivain: ${livre.ecrivainId}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
