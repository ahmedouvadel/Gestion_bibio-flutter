import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  // Fonction pour sélectionner une image
  Future<File?> selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Enregistrer l'image dans les assets
  Future<String> saveImageLocally(File imageFile, String fileName) async {
    try {
      // Obtenir le chemin vers le dossier des documents
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$fileName';

      // Copier l'image dans le dossier
      final savedImage = await imageFile.copy(path);
      return savedImage.path; // Retourner le chemin de l'image sauvegardée
    } catch (e) {
      throw Exception('Erreur lors de l\'enregistrement : $e');
    }
  }
}
