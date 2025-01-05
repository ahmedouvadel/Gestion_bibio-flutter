import 'dart:io';

import 'package:flutter/material.dart';
import '../models/livre.dart';

class LivreSearchDelegate extends SearchDelegate {
  final List<Livre> livres;
  final Function(Livre) onSelected;

  LivreSearchDelegate(this.livres, this.onSelected);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = livres.where((livre) {
      final titreLower = livre.titre.toLowerCase();
      final searchLower = query.toLowerCase();
      return titreLower.contains(searchLower);
    }).toList();

    return _buildStyledList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = livres.where((livre) {
      final titreLower = livre.titre.toLowerCase();
      final searchLower = query.toLowerCase();
      return titreLower.contains(searchLower);
    }).toList();

    return _buildStyledList(suggestions);
  }

  // Méthode pour construire la liste stylisée
  Widget _buildStyledList(List<Livre> livres) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: livres.length,
      itemBuilder: (context, index) {
        final livre = livres[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(livre.photo),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              livre.titre,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ISBN: ${livre.isbn}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Date: ${livre.dateSortie}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.green),
              onPressed: () => onSelected(livre),
            ),
            onTap: () => onSelected(livre),
          ),
        );
      },
    );
  }
}
