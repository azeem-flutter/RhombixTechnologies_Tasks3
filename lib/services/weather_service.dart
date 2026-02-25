import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TripWeatherData {
  final double temperatureC;
  final double feelsLikeC;
  final int humidity;
  final double windSpeedKmh;
  final int pressureHpa;
  final int cloudiness;
  final int rainChance;
  final String condition;

  const TripWeatherData({
    required this.temperatureC,
    required this.feelsLikeC,
    required this.humidity,
    required this.windSpeedKmh,
    required this.pressureHpa,
    required this.cloudiness,
    required this.rainChance,
    required this.condition,
  });
}

class WeatherService {
  static const String _apiBase = 'api.openweathermap.org';
  final String _apiKey;

  WeatherService({String? apiKey})
    : _apiKey =
          (apiKey ??
                  dotenv.env['OPENWEATHER_API_KEY'] ??
                  const String.fromEnvironment('OPENWEATHER_API_KEY'))
              .trim();

  Future<TripWeatherData> fetchTripWeather({
    required String location,
    required DateTime tripDate,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'OpenWeather key missing. Pass --dart-define=OPENWEATHER_API_KEY=YOUR_KEY',
      );
    }

    final geoData = await _resolveLocation(location);
    if (geoData == null || geoData.isEmpty) {
      throw Exception('Location not found for weather.');
    }

    final lat = (geoData.first['lat'] as num).toDouble();
    final lon = (geoData.first['lon'] as num).toDouble();

    String? forecastError;
    try {
      final forecastUri = Uri.https(_apiBase, '/data/2.5/forecast', {
        'lat': '$lat',
        'lon': '$lon',
        'appid': _apiKey,
        'units': 'metric',
      });

      final forecastResponse = await http.get(forecastUri);
      if (forecastResponse.statusCode == 200) {
        final forecastData =
            jsonDecode(forecastResponse.body) as Map<String, dynamic>;
        final entries = (forecastData['list'] as List<dynamic>? ?? const []);

        if (entries.isNotEmpty) {
          final closest =
              entries.reduce((a, b) {
                    final aTime = DateTime.parse(a['dt_txt'] as String);
                    final bTime = DateTime.parse(b['dt_txt'] as String);
                    final aDelta = aTime.difference(tripDate).inSeconds.abs();
                    final bDelta = bTime.difference(tripDate).inSeconds.abs();
                    return aDelta <= bDelta ? a : b;
                  })
                  as Map<String, dynamic>;

          return _fromForecastEntry(closest);
        }

        forecastError = 'Forecast data is empty.';
      } else {
        forecastError = _extractApiError(
          forecastResponse.body,
          fallback: 'Failed to fetch weather forecast.',
        );
      }
    } catch (error) {
      forecastError = error.toString().replaceFirst('Exception: ', '');
    }

    try {
      final currentUri = Uri.https(_apiBase, '/data/2.5/weather', {
        'lat': '$lat',
        'lon': '$lon',
        'appid': _apiKey,
        'units': 'metric',
      });
      final currentResponse = await http.get(currentUri);
      if (currentResponse.statusCode != 200) {
        final currentError = _extractApiError(
          currentResponse.body,
          fallback: 'Failed to fetch current weather.',
        );
        throw Exception(currentError);
      }

      final currentData =
          jsonDecode(currentResponse.body) as Map<String, dynamic>;
      return _fromCurrentWeather(currentData);
    } catch (error) {
      final currentError = error.toString().replaceFirst('Exception: ', '');
      if (forecastError != null && forecastError.isNotEmpty) {
        throw Exception(
          '$currentError (forecast fallback failed: $forecastError)',
        );
      }
      throw Exception(currentError);
    }
  }

  Future<List<dynamic>?> _resolveLocation(String rawLocation) async {
    final queries = _buildLocationQueries(rawLocation);

    for (final query in queries) {
      final geoUri = Uri.https(_apiBase, '/geo/1.0/direct', {
        'q': query,
        'limit': '1',
        'appid': _apiKey,
      });

      final geoResponse = await http.get(geoUri);
      if (geoResponse.statusCode != 200) {
        continue;
      }

      final geoData = jsonDecode(geoResponse.body) as List<dynamic>;
      if (geoData.isNotEmpty) {
        return geoData;
      }
    }

    return null;
  }

  List<String> _buildLocationQueries(String rawLocation) {
    final trimmed = rawLocation.trim();
    final parts = trimmed
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();

    final primary = parts.isNotEmpty ? parts.first : trimmed;
    final country = parts.length > 1 ? parts.last : '';

    final normalizedPrimary = primary
        .replaceAll('/', ' ')
        .replaceAll(RegExp(r'\bNational Park\b', caseSensitive: false), '')
        .replaceAll(RegExp(r'\bPark\b', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final candidates = <String>{
      if (trimmed.isNotEmpty) trimmed,
      if (trimmed.replaceAll('/', ' ').trim().isNotEmpty)
        trimmed.replaceAll('/', ' ').trim(),
      if (parts.isNotEmpty) parts.join(', '),
      if (primary.isNotEmpty) primary,
      if (normalizedPrimary.isNotEmpty) normalizedPrimary,
      if (normalizedPrimary.isNotEmpty && country.isNotEmpty)
        '$normalizedPrimary, $country',
      if (primary.contains('/'))
        ...primary
            .split('/')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty),
    };

    return candidates.toList();
  }

  String _extractApiError(String body, {required String fallback}) {
    try {
      final payload = jsonDecode(body);
      if (payload is Map<String, dynamic>) {
        final message = payload['message']?.toString().trim();
        if (message != null && message.isNotEmpty) {
          return message;
        }
      }
    } catch (_) {}
    return fallback;
  }

  TripWeatherData _fromForecastEntry(Map<String, dynamic> item) {
    final main = (item['main'] as Map<String, dynamic>? ?? const {});
    final wind = (item['wind'] as Map<String, dynamic>? ?? const {});
    final clouds = (item['clouds'] as Map<String, dynamic>? ?? const {});
    final weather = (item['weather'] as List<dynamic>? ?? const []);

    return TripWeatherData(
      temperatureC: (main['temp'] as num?)?.toDouble() ?? 0,
      feelsLikeC: (main['feels_like'] as num?)?.toDouble() ?? 0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      windSpeedKmh: ((wind['speed'] as num?)?.toDouble() ?? 0) * 3.6,
      pressureHpa: (main['pressure'] as num?)?.toInt() ?? 0,
      cloudiness: (clouds['all'] as num?)?.toInt() ?? 0,
      rainChance: (((item['pop'] as num?)?.toDouble() ?? 0) * 100).round(),
      condition: weather.isNotEmpty
          ? (weather.first['main'] as String? ?? 'Clear')
          : 'Clear',
    );
  }

  TripWeatherData _fromCurrentWeather(Map<String, dynamic> item) {
    final main = (item['main'] as Map<String, dynamic>? ?? const {});
    final wind = (item['wind'] as Map<String, dynamic>? ?? const {});
    final clouds = (item['clouds'] as Map<String, dynamic>? ?? const {});
    final weather = (item['weather'] as List<dynamic>? ?? const []);

    return TripWeatherData(
      temperatureC: (main['temp'] as num?)?.toDouble() ?? 0,
      feelsLikeC: (main['feels_like'] as num?)?.toDouble() ?? 0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      windSpeedKmh: ((wind['speed'] as num?)?.toDouble() ?? 0) * 3.6,
      pressureHpa: (main['pressure'] as num?)?.toInt() ?? 0,
      cloudiness: (clouds['all'] as num?)?.toInt() ?? 0,
      rainChance: 0,
      condition: weather.isNotEmpty
          ? (weather.first['main'] as String? ?? 'Clear')
          : 'Clear',
    );
  }
}
