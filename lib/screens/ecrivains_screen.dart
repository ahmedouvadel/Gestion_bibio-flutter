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
  final TextEditingController _searchController = TextEditingController();

  String? _currentId;
  List<Ecrivain> _ecrivains = [];
  List<Ecrivain> _filteredEcrivains = [];

  @override
  void initState() {
    super.initState();
    _fetchEcrivains();
  }

  // Récupérer les écrivains depuis la base de données
  void _fetchEcrivains() {
    _ecrivainService.obtenirEcrivains().listen((event) {
      if (event.snapshot.value != null) {
        final Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        final ecrivains = data.entries.map((entry) {
          final ecrivainData = Map<String, dynamic>.from(entry.value);
          return Ecrivain(
            id: entry.key,
            nom: ecrivainData['nom'],
            prenom: ecrivainData['prenom'],
            tel: ecrivainData['tel'],
          );
        }).toList();

        setState(() {
          _ecrivains = ecrivains;
          _filteredEcrivains = ecrivains; // Liste filtrée initiale
        });
      } else {
        setState(() {
          _ecrivains = [];
          _filteredEcrivains = [];
        });
      }
    });
  }

  // Recherche par nom, prénom ou téléphone
  void _searchEcrivains(String query) {
    setState(() {
      _filteredEcrivains = _ecrivains.where((ecrivain) {
        final fullName =
            '${ecrivain.nom.toLowerCase()} ${ecrivain.prenom.toLowerCase()}';
        final tel = ecrivain.tel.toLowerCase();
        final searchLower = query.toLowerCase();
        return fullName.contains(searchLower) || tel.contains(searchLower);
      }).toList();
    });
  }

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
        _ecrivainService.ajouterEcrivain(ecrivain.toMap()).then((_) {
          Navigator.pop(context);
        });
      } else {
        _ecrivainService
            .mettreAJourEcrivain(_currentId!, ecrivain.toMap())
            .then((_) {
          Navigator.pop(context);
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

  // Boîte de dialogue pour ajouter/modifier un écrivain
  void afficherDialogueAjoutOuModification(BuildContext context,
      {Ecrivain? ecrivain}) {
    if (ecrivain != null) {
      _nomController.text = ecrivain.nom;
      _prenomController.text = ecrivain.prenom;
      _telController.text = ecrivain.tel;
      _currentId = ecrivain.id;
    } else {
      _nomController.clear();
      _prenomController.clear();
      _telController.clear();
      _currentId = null;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Coins arrondis
          ),
          title: Row(
            children: [
              Icon(
                ecrivain == null
                    ? Icons.person_add
                    : Icons.edit, // Icône dynamique
                color: Colors.green,
              ),
              const SizedBox(width: 8), // Espacement
              Text(
                ecrivain == null
                    ? 'Ajouter un Écrivain'
                    : 'Modifier un Écrivain',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nom
                TextField(
                  controller: _nomController,
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    prefixIcon: const Icon(Icons.person), // Icône pour le nom
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12), // Espacement

                // Prénom
                TextField(
                  controller: _prenomController,
                  decoration: InputDecoration(
                    labelText: 'Prénom',
                    prefixIcon:
                        const Icon(Icons.person_outline), // Icône pour prénom
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Téléphone
                TextField(
                  controller: _telController,
                  decoration: InputDecoration(
                    labelText: 'Téléphone',
                    prefixIcon: const Icon(Icons.phone), // Icône pour téléphone
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            // Bouton Annuler
            TextButton.icon(
              icon:
                  const Icon(Icons.cancel, color: Colors.red), // Icône annulée
              label: const Text('Annuler'),
              onPressed: () => Navigator.pop(context),
            ),

            // Bouton Ajouter ou Modifier
            ElevatedButton.icon(
              icon: Icon(
                ecrivain == null ? Icons.add : Icons.edit, // Icône dynamique
                color: Colors.white,
              ),
              label: Text(ecrivain == null ? 'Ajouter' : 'Modifier'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green, // Couleur verte pour correspondre au thème
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher par nom ou téléphone...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _searchEcrivains,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredEcrivains.length,
              itemBuilder: (context, index) {
                final ecrivain = _filteredEcrivains[index];
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text('${ecrivain.nom} ${ecrivain.prenom}'),
                    subtitle: Text(ecrivain.tel),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.phone, color: Colors.green),
                          onPressed: () => appelerEcrivain(ecrivain.tel),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => afficherDialogueAjoutOuModification(
                              context,
                              ecrivain: ecrivain),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _ecrivainService.supprimerEcrivain(
                            ecrivain.id,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => afficherDialogueAjoutOuModification(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
