import 'package:firebase_database/firebase_database.dart';
import '../models/livre.dart';

class LivreService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('livres');

  // Ajouter un livre
  Future<void> ajouterLivre(Livre livre) async {
    try {
      await _db.push().set(livre.toMap());
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du livre : $e');
    }
  }

  // Mettre à jour un livre
  Future<void> mettreAJourLivre(String key, Livre livre) async {
    try {
      await _db.child(key).update(livre.toMap());
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du livre : $e');
    }
  }

  // Lire les livres
  Stream<List<Livre>> obtenirLivres() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return []; // Retourne une liste vide si aucune donnée

      return data.entries.map((entry) {
        final livreData = Map<String, dynamic>.from(entry.value);
        return Livre.fromMap(livreData);
      }).toList();
    });
  }

  // Supprimer un livre
  Future<void> supprimerLivre(String key) async {
    try {
      // Supprimer le livre de Firebase
      await _db.child(key).remove();
    } catch (e) {
      throw Exception('Erreur lors de la suppression du livre : $e');
    }
  }
}
