// lib/views/trip_detail/widgets/weather_cards_row.dart
import 'package:flutter/material.dart';

class WeatherCardsRow extends StatelessWidget {
  final String temperature;
  final String windSpeed;
  final String humidity;

  const WeatherCardsRow({
    super.key,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _WeatherCard(
              icon: Icons.wb_sunny_rounded,
              label: 'Temperature',
              value: temperature,
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD89B), Color(0xFFFF9A56)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _WeatherCard(
              icon: Icons.air_rounded,
              label: 'Wind',
              value: windSpeed,
              gradient: const LinearGradient(
                colors: [Color(0xFF84FAB0), Color(0xFF8FD3F4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _WeatherCard(
              icon: Icons.water_drop_rounded,
              label: 'Humidity',
              value: humidity,
              gradient: const LinearGradient(
                colors: [Color(0xFFA8EDEA), Color(0xFFFED6E3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
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
              fontSize: 20,
            ),
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
