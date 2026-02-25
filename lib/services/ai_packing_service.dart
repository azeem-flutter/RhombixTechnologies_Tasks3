import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:trailmate/models/Trip/trip_models.dart';
import 'package:trailmate/services/weather_service.dart';

class GeneratedPackingList {
  final String provider;
  final List<String> items;

  const GeneratedPackingList({required this.provider, required this.items});
}

class AiPackingService {
  final String _openAiKey;
  final String _geminiKey;

  AiPackingService({String? openAiKey, String? geminiKey})
    : _openAiKey =
          openAiKey ??
          dotenv.env['OPENAI_API_KEY'] ??
          const String.fromEnvironment('OPENAI_API_KEY'),
      _geminiKey =
          geminiKey ??
          dotenv.env['GEMINI_API_KEY'] ??
          const String.fromEnvironment('GEMINI_API_KEY');

  Future<GeneratedPackingList> generatePackingList({
    required TripModels trip,
    required TripWeatherData? weather,
  }) async {
    final prompt = _buildPrompt(trip: trip, weather: weather);

    final fromOpenAi = await _generateWithOpenAi(prompt);
    if (fromOpenAi.isNotEmpty) {
      return GeneratedPackingList(provider: 'ChatGPT', items: fromOpenAi);
    }

    final fromGemini = await _generateWithGemini(prompt);
    if (fromGemini.isNotEmpty) {
      return GeneratedPackingList(provider: 'Gemini', items: fromGemini);
    }

    return GeneratedPackingList(
      provider: 'Smart fallback',
      items: _fallbackList(trip, weather),
    );
  }

  String _buildPrompt({
    required TripModels trip,
    required TripWeatherData? weather,
  }) {
    final weatherText = weather == null
        ? 'Weather unavailable.'
        : 'Condition: ${weather.condition}, Temp: ${weather.temperatureC.toStringAsFixed(0)}°C, Feels like: ${weather.feelsLikeC.toStringAsFixed(0)}°C, Humidity: ${weather.humidity}%, Wind: ${weather.windSpeedKmh.toStringAsFixed(0)} km/h, Rain chance: ${weather.rainChance}%';

    return 'Generate a concise hiking/camping packing list for this trip. Trip title: ${trip.tripTitle}. Location: ${trip.location}. Trip type: ${trip.tripType}. Difficulty: ${trip.difficultyLevel}. Members: ${trip.members}. Start: ${trip.startDate.toIso8601String()}. End: ${trip.endDate.toIso8601String()}. Trip image url: ${trip.imageUrl}. Weather context: $weatherText. Return 12 short bullet items only, no categories, no numbering.';
  }

  Future<List<String>> _generateWithOpenAi(String prompt) async {
    if (_openAiKey.isEmpty) {
      return const [];
    }

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_openAiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You generate practical outdoor packing checklists in compact bullets.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.4,
        }),
      );

      if (response.statusCode != 200) {
        return const [];
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final content =
          (((body['choices'] as List<dynamic>? ?? const []).firstOrNull
                      as Map<String, dynamic>?)?['message']
                  as Map<String, dynamic>?)?['content']
              as String?;

      return _normalizeList(content ?? '');
    } catch (_) {
      return const [];
    }
  }

  Future<List<String>> _generateWithGemini(String prompt) async {
    if (_geminiKey.isEmpty) {
      return const [];
    }

    try {
      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_geminiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode != 200) {
        return const [];
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = (body['candidates'] as List<dynamic>? ?? const []);
      if (candidates.isEmpty) {
        return const [];
      }

      final content = candidates.first['content'] as Map<String, dynamic>?;
      final parts = (content?['parts'] as List<dynamic>? ?? const []);
      if (parts.isEmpty) {
        return const [];
      }

      final text = parts.first['text'] as String? ?? '';
      return _normalizeList(text);
    } catch (_) {
      return const [];
    }
  }

  List<String> _normalizeList(String raw) {
    final lines = raw
        .split('\n')
        .map(
          (line) => line.replaceFirst(RegExp(r'^\s*[-*\d\.)]+\s*'), '').trim(),
        )
        .where((line) => line.isNotEmpty)
        .toList();

    final deduped = <String>[];
    for (final line in lines) {
      if (!deduped.any(
        (existing) => existing.toLowerCase() == line.toLowerCase(),
      )) {
        deduped.add(line);
      }
    }

    return deduped.take(12).toList();
  }

  List<String> _fallbackList(TripModels trip, TripWeatherData? weather) {
    final list = <String>[
      'Hydration pack or water bottles',
      'Trail snacks and energy bars',
      'First aid kit with bandages',
      'Phone, power bank, and charging cable',
      'Headlamp with spare batteries',
      'Navigation support (offline map/compass)',
    ];

    final isCold = (weather?.temperatureC ?? 20) < 12;
    final rainy =
        (weather?.rainChance ?? 0) >= 35 ||
        (weather?.condition.toLowerCase().contains('rain') ?? false);

    if (isCold) {
      list.add('Thermal layer and insulated jacket');
      list.add('Warm gloves and beanie');
    } else {
      list.add('Lightweight breathable clothing');
      list.add('Sun hat and UV protection');
    }

    if (rainy) {
      list.add('Rain jacket and backpack cover');
    }

    if (trip.tripType.toLowerCase() == 'camping') {
      list.add('Tent, stakes, and sleeping setup');
    }

    return list.take(12).toList();
  }
}

extension on List<dynamic> {
  dynamic get firstOrNull => isEmpty ? null : first;
}
