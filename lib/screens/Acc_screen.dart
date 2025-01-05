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

  void _fetchLivres() {
    _livreService.obtenirLivres().listen((livres) {
      setState(() {
        _livres = livres;
        _filteredLivres = livres;
      });
    });
  }

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
        title: const Text('Choisissez un livre'),
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section "Our Top Picks"
          Container(
            color: const Color(0xFFEEEEEE), // Nouvelle couleur de fond
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nos meilleurs choix",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filteredLivres.length,
                    itemBuilder: (context, index) {
                      final livre = _filteredLivres[index];
                      return GestureDetector(
                        onTap: () => _showDetails(livre),
                        child: Container(
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
                              ],
                            ),
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

          // Section "Bestsellers"
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Meilleures ventes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Grille de livres
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredLivres.length,
            itemBuilder: (context, index) {
              final livre = _filteredLivres[index];
              return GestureDetector(
                onTap: () => _showDetails(livre),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(livre.photo),
                            height: 100,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                livre.titre,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: List.generate(5, (index) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.green,
                                    size: 16,
                                  );
                                }),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('ajouter'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton(
                                    onPressed: () {},
                                    child: const Text('Liste de souhaits'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
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
