import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TripChatService {
  final String _openAiKey;
  final String _geminiKey;

  TripChatService({String? openAiKey, String? geminiKey})
    : _openAiKey =
          openAiKey ??
          dotenv.env['OPENAI_API_KEY'] ??
          const String.fromEnvironment('OPENAI_API_KEY'),
      _geminiKey =
          geminiKey ??
          dotenv.env['GEMINI_API_KEY'] ??
          const String.fromEnvironment('GEMINI_API_KEY');

  static const List<String> _tripKeywords = [
    'trip',
    'travel',
    'tour',
    'itinerary',
    'plan',
    'planning',
    'destination',
    'location',
    'place',
    'camp',
    'camping',
    'hike',
    'hiking',
    'mountain',
    'trek',
    'trail',
    'weather',
    'forecast',
    'packing',
    'gear',
    'backpack',
    'hotel',
    'stay',
    'transport',
    'budget',
    'cost',
    'flight',
    'booking',
    'visa',
    'passport',
    'safety',
    'safe',
    'safty',
  ];

  Future<String> ask(String userMessage) async {
    if (!_isTripRelated(userMessage)) {
      return 'I can help only with trip-related topics like destination planning, itinerary, weather, budget, transport, packing list, and safety.';
    }

    final openAiReply = await _askOpenAi(userMessage);
    if (openAiReply.isNotEmpty) {
      return openAiReply;
    }

    final geminiReply = await _askGemini(userMessage);
    if (geminiReply.isNotEmpty) {
      return geminiReply;
    }

    return _fallbackTripResponse(userMessage);
  }

  bool _isTripRelated(String message) {
    final lower = message.toLowerCase();

    if (_tripKeywords.any(lower.contains)) {
      return true;
    }

    final tokens = lower
        .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty)
        .toList();

    const keywordRoots = [
      'trip',
      'travel',
      'itiner',
      'destin',
      'locat',
      'camp',
      'hike',
      'trail',
      'mount',
      'trek',
      'weath',
      'pack',
      'gear',
      'hotel',
      'transp',
      'budg',
      'cost',
      'flight',
      'book',
      'visa',
      'passp',
      'safe',
      'saft',
    ];

    return tokens.any((token) => keywordRoots.any(token.startsWith));
  }

  Future<String> _askOpenAi(String userMessage) async {
    if (_openAiKey.isEmpty) {
      return '';
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
          'temperature': 0.4,
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a travel planner assistant. Answer only trip-related questions. If the user asks anything not related to trip planning, travel logistics, weather for trip, itinerary, packing, safety, or destinations, politely refuse in one sentence. Keep responses practical and concise.',
            },
            {'role': 'user', 'content': userMessage},
          ],
        }),
      );

      if (response.statusCode != 200) {
        return '';
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = (data['choices'] as List<dynamic>? ?? const []);
      if (choices.isEmpty) {
        return '';
      }

      final message = choices.first['message'] as Map<String, dynamic>?;
      final content = (message?['content'] as String?)?.trim() ?? '';
      return content;
    } catch (_) {
      return '';
    }
  }

  Future<String> _askGemini(String userMessage) async {
    if (_geminiKey.isEmpty) {
      return '';
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
                {
                  'text':
                      'You are a travel planner assistant. Answer only trip-related questions. If question is unrelated, politely refuse in one sentence. Keep response practical and concise.\n\nUser: $userMessage',
                },
              ],
            },
          ],
        }),
      );

      if (response.statusCode != 200) {
        return '';
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = (data['candidates'] as List<dynamic>? ?? const []);
      if (candidates.isEmpty) {
        return '';
      }

      final content = candidates.first['content'] as Map<String, dynamic>?;
      final parts = (content?['parts'] as List<dynamic>? ?? const []);
      if (parts.isEmpty) {
        return '';
      }

      return (parts.first['text'] as String?)?.trim() ?? '';
    } catch (_) {
      return '';
    }
  }

  String _fallbackTripResponse(String userMessage) {
    final msg = userMessage.toLowerCase();

    if (msg.contains('safety') ||
        msg.contains('safe') ||
        msg.contains('safty') ||
        msg.contains('mountain') ||
        msg.contains('hike') ||
        msg.contains('trek')) {
      return 'For mountain trip safety: check weather before departure, share your route and ETA, carry water + first-aid + power bank + flashlight, wear proper shoes/layers, start early, stay on marked paths, and avoid hiking alone after dark.';
    }

    if (msg.contains('itinerary') || msg.contains('plan')) {
      return 'A practical trip itinerary format: Day-wise plan, travel times, key activities, meal breaks, backup indoor options, and a final emergency contact note.';
    }

    if (msg.contains('destination') ||
        msg.contains('where') ||
        msg.contains('location') ||
        msg.contains('place')) {
      return 'I can help choose destination based on your budget, days available, weather preference, and activity type. Tell me those 4 details and I will suggest a trip plan.';
    }

    if (msg.contains('packing') || msg.contains('gear')) {
      return 'For a balanced trip packing list: ID/documents, weather-appropriate clothing layers, comfortable shoes, toiletries, charger/power bank, first-aid kit, and water/snacks.';
    }

    if (msg.contains('weather')) {
      return 'For trip weather planning: check forecast for temperature range, rain chance, wind, and humidity, then pack in layers and include rain protection.';
    }

    if (msg.contains('budget')) {
      return 'A simple trip budget split is: transport 35%, stay 35%, food 20%, activities 10%. Add a 10% emergency buffer if possible.';
    }

    return 'I can help with trip planning, itinerary, packing, weather prep, transport, and budget. Ask me any trip-related question.';
  }
}
