import 'package:flutter/material.dart';
import 'dart:io';
import '../models/livre.dart';
import '../services/livre_service.dart';
import 'livre_details.dart';

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section "Top Picks" avec arrière-plan coloré
            Container(
              color: Colors.green.shade300,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Our Top Picks",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200, // Hauteur fixe pour défiler horizontalement
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filteredLivres.length,
                      itemBuilder: (context, index) {
                        final livre = _filteredLivres[index];
                        return Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 10),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: Image.file(
                                    File(livre.photo),
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Titre
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    livre.titre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // ISBN
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    'ISBN: ${livre.isbn}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Section "Bestsellers" en grille
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Bestsellers",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _filteredLivres.length,
              itemBuilder: (context, index) {
                final livre = _filteredLivres[index];
                return GestureDetector(
                  onTap: () => _showDetails(livre),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.file(
                            File(livre.photo),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            livre.titre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'ISBN: ${livre.isbn}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
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
