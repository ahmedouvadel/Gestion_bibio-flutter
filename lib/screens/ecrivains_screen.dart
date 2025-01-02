import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Pour appeler
import '../models/ecrivain.dart';
import '../services/ecrivain_service.dart';

class EcrivainsScreen extends StatefulWidget {
  const EcrivainsScreen({Key? key}) : super(key: key);

  @override
  State<EcrivainsScreen> createState() => _EcrivainsScreenState();
}

class _EcrivainsScreenState extends State<EcrivainsScreen> {
  final EcrivainService _ecrivainService = EcrivainService();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telController = TextEditingController();

  String? _currentId; // Pour identifier l'écrivain sélectionné

  // Ajouter ou modifier un écrivain
  void ajouterOuModifierEcrivain() {
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();
    final tel = _telController.text.trim();

    if (nom.isNotEmpty && prenom.isNotEmpty && tel.isNotEmpty) {
      final ecrivain = Ecrivain(
        id: _currentId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nom: nom,
        prenom: prenom,
        tel: tel,
      );

      if (_currentId == null) {
        // Ajouter un nouvel écrivain
        _ecrivainService.ajouterEcrivain(ecrivain.toMap()).then((_) {
          Navigator.pop(context); // Fermer le dialogue après l'ajout
        });
      } else {
        // Modifier l'écrivain existant
        _ecrivainService
            .mettreAJourEcrivain(_currentId!, ecrivain.toMap())
            .then((_) {
          Navigator.pop(context); // Fermer le dialogue après la mise à jour
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tous les champs sont obligatoires')),
      );
    }
  }

  // Appeler un écrivain
  void appelerEcrivain(String tel) async {
    final Uri url = Uri(scheme: 'tel', path: tel);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'appeler ce numéro')),
      );
    }
  }

  // Afficher la boîte de dialogue pour ajouter/modifier un écrivain
  void afficherDialogueAjoutOuModification(BuildContext context,
      {Ecrivain? ecrivain}) {
    if (ecrivain != null) {
      // Pré-remplir les champs pour la modification
      _nomController.text = ecrivain.nom;
      _prenomController.text = ecrivain.prenom;
      _telController.text = ecrivain.tel;
      _currentId = ecrivain.id;
    } else {
      // Réinitialiser pour l'ajout
      _nomController.clear();
      _prenomController.clear();
      _telController.clear();
      _currentId = null;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ecrivain == null
              ? 'Ajouter un Écrivain'
              : 'Modifier un Écrivain'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom'),
              ),
              TextField(
                controller: _telController,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(ecrivain == null ? 'Ajouter' : 'Modifier'),
              onPressed: ajouterOuModifierEcrivain,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Écrivains'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _ecrivainService.obtenirEcrivains(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final Map<dynamic, dynamic> data =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final ecrivains = data.entries.map((entry) {
            final ecrivainData = Map<String, dynamic>.from(entry.value);
            return Ecrivain(
              id: entry.key,
              nom: ecrivainData['nom'],
              prenom: ecrivainData['prenom'],
              tel: ecrivainData['tel'],
            );
          }).toList();

          return ListView.builder(
            itemCount: ecrivains.length,
            itemBuilder: (context, index) {
              final ecrivain = ecrivains[index];
              return ListTile(
                title: Text('${ecrivain.nom} ${ecrivain.prenom}'),
                subtitle: Text(ecrivain.tel),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => afficherDialogueAjoutOuModification(
                          context,
                          ecrivain: ecrivain),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _ecrivainService.supprimerEcrivain(
                        ecrivain.id,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone),
                      onPressed: () => appelerEcrivain(ecrivain.tel),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => afficherDialogueAjoutOuModification(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
