import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class CloudinaryService {
  // Informations Cloudinary (remplace par tes vraies valeurs)
  final String cloudName = "dncrt1dgo"; // Ton nom Cloudinary
  final String apiKey = "243945199968947"; // Ta clé API
  final String uploadPreset = "gestion_beblio"; // Ton preset d'upload
  final String apiSecret = "tt-ysaiar0kq432A4aFMPvihPFw"; // Ton secret API

  /// **Téléverser une image vers Cloudinary**
  Future<String?> uploadImage(File imageFile) async {
    try {
      // URL d'upload Cloudinary
      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      // Préparer la requête multipart
      final request = http.MultipartRequest('POST', url);

      // Ajouter le preset
      request.fields['upload_preset'] = uploadPreset;

      // Ajouter le fichier
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'), // Adapter selon le format
      ));

      // Envoyer la requête
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = json.decode(await response.stream.bytesToString());
        return responseData['secure_url']; // Retourne l'URL de l'image
      } else {
        final error = json.decode(await response.stream.bytesToString());
        throw Exception('Échec de l\'upload : ${error['error']['message']}');
      }
    } catch (e) {
      throw Exception('Erreur : $e');
    }
  }

  /// **Supprimer une image depuis Cloudinary**
  Future<void> supprimerImage(String publicId) async {
    try {
      // URL de suppression Cloudinary
      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/destroy');

      // Préparer la requête
      final response = await http.post(url, body: {
        'public_id': publicId,
        'upload_preset': uploadPreset,
        'api_key': apiKey,
      });

      if (response.statusCode != 200) {
        final errorResponse = json.decode(response.body);
        throw Exception(
            'Erreur lors de la suppression : ${errorResponse['error']['message']}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression : $e');
    }
  }
}
