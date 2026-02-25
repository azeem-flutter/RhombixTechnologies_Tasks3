// lib/views/trip_detail/widgets/weather_cards_row.dart
import 'package:flutter/material.dart';

class WeatherCardsRow extends StatelessWidget {
  final String temperature;
  final String windSpeed;
  final String humidity;
  final String feelsLike;
  final String pressure;
  final String condition;

  const WeatherCardsRow({
    super.key,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.feelsLike,
    required this.pressure,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      _WeatherCard(
        icon: Icons.wb_sunny_rounded,
        label: 'Temperature',
        value: temperature,
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD89B), Color(0xFFFF9A56)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _WeatherCard(
        icon: Icons.air_rounded,
        label: 'Wind',
        value: windSpeed,
        gradient: const LinearGradient(
          colors: [Color(0xFF84FAB0), Color(0xFF8FD3F4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _WeatherCard(
        icon: Icons.water_drop_rounded,
        label: 'Humidity',
        value: humidity,
        gradient: const LinearGradient(
          colors: [Color(0xFFA8EDEA), Color(0xFFFED6E3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _WeatherCard(
        icon: Icons.thermostat_rounded,
        label: 'Feels Like',
        value: feelsLike,
        gradient: const LinearGradient(
          colors: [Color(0xFFf6d365), Color(0xFFfda085)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _WeatherCard(
        icon: Icons.speed_rounded,
        label: 'Pressure',
        value: pressure,
        gradient: const LinearGradient(
          colors: [Color(0xFF89f7fe), Color(0xFF66a6ff)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _WeatherCard(
        icon: Icons.cloud_rounded,
        label: 'Condition',
        value: condition,
        gradient: const LinearGradient(
          colors: [Color(0xFFcfd9df), Color(0xFFe2ebf0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: cards
            .map(
              (card) => SizedBox(
                width: (MediaQuery.of(context).size.width - 64) / 2,
                child: card,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Gradient gradient;

  const _WeatherCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20), // 0.08 * 255 = 20.4 ≈ 20
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 32,
            shadows: [
              Shadow(
                color: Colors.black.withAlpha(51), // 0.2 * 255 = 51
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha(242), // 0.95 * 255 = 242.25 ≈ 242
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
