import 'dart:io';
import 'package:flutter/material.dart';
import '../models/livre.dart';
import '../services/livre_service.dart';
import '../services/image_service.dart';

class LivresScreen extends StatefulWidget {
  const LivresScreen({Key? key}) : super(key: key);

  @override
  State<LivresScreen> createState() => _LivresScreenState();
}

class _LivresScreenState extends State<LivresScreen> {
  final LivreService _livreService = LivreService();
  final ImageService _imageService = ImageService();

  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _dateSortieController = TextEditingController();
  final TextEditingController _ecrivainIdController = TextEditingController();

  File? _imageFile;
  String? _currentKey;

  Future<void> _selectImage() async {
    final image = await _imageService.selectImage();
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  Future<void> ajouterOuModifierLivre() async {
    final titre = _titreController.text.trim();
    final isbn = _isbnController.text.trim();
    final dateSortie = _dateSortieController.text.trim();
    final ecrivainId = _ecrivainIdController.text.trim();

    if (titre.isNotEmpty &&
        isbn.isNotEmpty &&
        dateSortie.isNotEmpty &&
        _imageFile != null &&
        ecrivainId.isNotEmpty) {
      try {
        final imagePath = await _imageService.saveImageLocally(
            _imageFile!, '${DateTime.now().millisecondsSinceEpoch}.jpg');

        final livre = Livre(
          id: _currentKey ?? DateTime.now().millisecondsSinceEpoch.toString(),
          titre: titre,
          isbn: isbn,
          dateSortie: dateSortie,
          photo: imagePath,
          ecrivainId: ecrivainId,
        );

        if (_currentKey == null) {
          await _livreService.ajouterLivre(livre);
        } else {
          await _livreService.mettreAJourLivre(_currentKey!, livre);
        }

        _resetFields();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tous les champs sont obligatoires')),
      );
    }
  }

  void _resetFields() {
    _titreController.clear();
    _isbnController.clear();
    _dateSortieController.clear();
    _ecrivainIdController.clear();
    setState(() {
      _imageFile = null;
      _currentKey = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Livres'),
      ),
      body: StreamBuilder<List<Livre>>(
        stream: _livreService.obtenirLivres(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final livres = snapshot.data!;
          return ListView.builder(
            itemCount: livres.length,
            itemBuilder: (context, index) {
              final livre = livres[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'ISBN: ${livre.isbn}\nDate: ${livre.dateSortie}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _afficherDialogueModification(context, livre),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _livreService.supprimerLivre(livre.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Livre supprimé !')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _afficherDialogueAjout(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _afficherDialogueAjout(BuildContext context) {
    _resetFields();
    _afficherDialogue(context);
  }

  void _afficherDialogueModification(BuildContext context, Livre livre) {
    _titreController.text = livre.titre;
    _isbnController.text = livre.isbn;
    _dateSortieController.text = livre.dateSortie;
    _ecrivainIdController.text = livre.ecrivainId;
    _imageFile = File(livre.photo);
    _currentKey = livre.id;

    _afficherDialogue(context);
  }

  void _afficherDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.book, color: Colors.green),
              const SizedBox(width: 8),
              const Text(
                'Ajouter/Modifier Livre',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_titreController, 'Titre', Icons.title),
                _buildTextField(_isbnController, 'ISBN', Icons.code),
                _buildTextField(
                    _dateSortieController, 'Date de Sortie', Icons.date_range),
                _buildTextField(
                    _ecrivainIdController, 'ID Écrivain', Icons.person_outline),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Sélectionner une image'),
                  onPressed: _selectImage,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: ajouterOuModifierLivre,
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildTextField(
    TextEditingController controller, String label, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon), // Icône avant le texte
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Coins arrondis
        ),
      ),
    ),
  );
}
