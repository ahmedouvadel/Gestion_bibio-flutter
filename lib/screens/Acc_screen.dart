import 'package:flutter/material.dart';
import 'dart:io';
import '../models/livre.dart';
import '../services/livre_service.dart';

class AccScreen extends StatefulWidget {
  const AccScreen({super.key});

  @override
  State<AccScreen> createState() => _AccScreenState();
}

class _AccScreenState extends State<AccScreen> {
  final LivreService _livreService = LivreService();
  List<Livre> _livres = [];
  List<Livre> _filteredLivres = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchLivres();
  }

  // Fetch books from the database
  void _fetchLivres() {
    _livreService.obtenirLivres().listen((livres) {
      setState(() {
        _livres = livres;
        _filteredLivres = livres; // Initial filter
      });
    });
  }

  // Search filter
  void _searchLivres(String query) {
    setState(() {
      _searchQuery = query;
      _filteredLivres = _livres.where((livre) {
        final titreLower = livre.titre.toLowerCase();
        final searchLower = query.toLowerCase();
        return titreLower.contains(searchLower);
      }).toList();
    });
  }

  // Navigate to book details
  void _showDetails(Livre livre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivreDetailsScreen(livre: livre),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de Bibliothèque'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: LivreSearchDelegate(_livres, _showDetails),
              );
            },
          ),
        ],
      ),
      body: _filteredLivres.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _filteredLivres.length,
              itemBuilder: (context, index) {
                final livre = _filteredLivres[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.file(
                      File(livre.photo),
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(livre.titre),
                  subtitle: Text('ISBN: ${livre.isbn}'),
                  onTap: () => _showDetails(livre),
                );
              },
            ),
    );
  }
}

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

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final livre = results[index];
        return ListTile(
          title: Text(livre.titre),
          subtitle: Text('ISBN: ${livre.isbn}'),
          onTap: () => onSelected(livre),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = livres.where((livre) {
      final titreLower = livre.titre.toLowerCase();
      final searchLower = query.toLowerCase();
      return titreLower.contains(searchLower);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final livre = suggestions[index];
        return ListTile(
          title: Text(livre.titre),
          subtitle: Text('ISBN: ${livre.isbn}'),
          onTap: () => onSelected(livre),
        );
      },
    );
  }
}

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
