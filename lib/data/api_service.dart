import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = 'TON_API_KEY_NINJA'; // <--- METS TA CLÉ ICI

  static Future<String> getTranslatedQuote() async {
    try {
      // 1. On récupère la citation en anglais
      final quoteUri = Uri.parse('https://api.api-ninjas.com/v1/quotes?category=inspirational');
      final quoteRes = await http.get(quoteUri, headers: {'X-Api-Key': apiKey});

      if (quoteRes.statusCode == 200) {
        final String textEn = json.decode(quoteRes.body)[0]['quote'];

        // 2. On traduit le texte récupéré en français
        final transUri = Uri.parse('https://api.api-ninjas.com/v1/translator?text=${Uri.encodeComponent(textEn)}&target=fr');
        final transRes = await http.get(transUri, headers: {'X-Api-Key': apiKey});

        if (transRes.statusCode == 200) {
          return json.decode(transRes.body)['translated_text'];
        }
        return textEn; // Retourne l'anglais si la traduction échoue
      }
    } catch (e) {
      print("Erreur : $e");
    }
    return "Erreur de connexion";
  }
}