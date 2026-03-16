import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  final String baseUrl;
  final String apiKey;
  final String? channel;
  final String? campaign;

  AppConfig({required this.baseUrl, required this.apiKey, this.channel, this.campaign});

  factory AppConfig.fromEnv() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000';
    final apiKey = dotenv.env['API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      throw Exception('API key is missing. Set it in .env (API_KEY) or env vars.');
    }

    return AppConfig(baseUrl: baseUrl, apiKey: apiKey, channel: dotenv.env['CHANNEL'], campaign: dotenv.env['CAMPAIGN']);
  }
}
