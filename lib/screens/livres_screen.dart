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

  // Sélectionner une image
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
          photo: imagePath, // Utiliser le chemin local
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
              return ListTile(
                title: Text(livre.titre),
                subtitle:
                    Text('ISBN: ${livre.isbn}\nDate: ${livre.dateSortie}'),
                leading: Image.file(
                  File(livre.photo),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _afficherDialogueModification(context, livre),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _livreService.supprimerLivre(livre.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Livre supprimé !')),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _afficherDialogueAjout(context),
        child: const Icon(Icons.add),
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
          title: const Text('Ajouter/Modifier un Livre'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titreController,
                  decoration: const InputDecoration(labelText: 'Titre'),
                ),
                TextField(
                  controller: _isbnController,
                  decoration: const InputDecoration(labelText: 'ISBN'),
                ),
                TextField(
                  controller: _dateSortieController,
                  decoration:
                      const InputDecoration(labelText: 'Date de Sortie'),
                ),
                TextButton(
                  onPressed: _selectImage,
                  child: _imageFile == null
                      ? const Text('Sélectionner une image')
                      : Image.file(
                          _imageFile!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                ),
                TextField(
                  controller: _ecrivainIdController,
                  decoration: const InputDecoration(labelText: 'ID Écrivain'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Enregistrer'),
              onPressed: ajouterOuModifierLivre,
            ),
          ],
        );
      },
    );
  }
}
