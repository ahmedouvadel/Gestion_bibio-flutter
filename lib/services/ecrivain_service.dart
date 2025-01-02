import 'package:firebase_database/firebase_database.dart';

class EcrivainService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('ecrivains');

  // Ajouter un écrivain
  Future<void> ajouterEcrivain(Map<String, dynamic> ecrivain) async {
    try {
      await _db.push().set(ecrivain);
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout : $e');
    }
  }

  // Lire les écrivains
  Stream<DatabaseEvent> obtenirEcrivains() {
    return _db.onValue;
  }

  // Supprimer un écrivain
  Future<void> supprimerEcrivain(String key) async {
    try {
      await _db.child(key).remove();
    } catch (e) {
      throw Exception('Erreur lors de la suppression : $e');
    }
  }

  // **Mettre à jour un écrivain**
  Future<void> mettreAJourEcrivain(
      String key, Map<String, dynamic> ecrivain) async {
    try {
      await _db.child(key).update(ecrivain); // Mise à jour avec le key fourni
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour : $e');
    }
  }
}
