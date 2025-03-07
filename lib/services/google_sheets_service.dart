import 'dart:developer';
import 'package:http/http.dart' as http;

class GoogleSheetsService {
  // URL do seu script do Google Apps
  static const String _url = 'URL DO SCRIPT DO GOOGLE';

  // função que envia os dados para o Google Sheets
  static Future<void> sendExpenseToGoogleSheets(
    String category,
    String amount,
  ) async {
    try {
      // dados que serão enviados
      final Map<String, String> data = {
        'category': category,
        'amount': amount,
        'date': DateTime.now().toString(),
      };

      // enviar os dados para o Google Sheets via POST
      final response = await http.post(Uri.parse(_url), body: data);
      log("${response.statusCode}");
      log(response.body);
      // verificando se a resposta foi bem-sucedida

      // está retornando um statusCode incorreto mas as respostas estão sendo enviadas (????)

      if (response.statusCode == 200) {
        log("Dados enviados com sucesso para o Google Sheets.");
      } else {
        log("Falha ao enviar dados. Status: ${response.statusCode}");
      }
    } catch (e) {
      log("Erro ao enviar dados: $e");
    }
  }
}
