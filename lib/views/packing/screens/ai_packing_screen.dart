import 'package:flutter/material.dart';
import 'package:trailmate/models/Trip/packing_item.dart';
import 'package:trailmate/models/Trip/trip_models.dart';
import 'package:trailmate/services/ai_packing_service.dart';
import 'package:trailmate/services/weather_service.dart';
import 'package:trailmate/views/packing/widgets/packing_item_tile.dart';

class AiPackingScreen extends StatefulWidget {
  final TripModels trip;

  const AiPackingScreen({super.key, required this.trip});

  @override
  State<AiPackingScreen> createState() => _AiPackingScreenState();
}

class _AiPackingScreenState extends State<AiPackingScreen> {
  final AiPackingService _aiPackingService = AiPackingService();
  final WeatherService _weatherService = WeatherService();

  bool _isLoading = true;
  String? _error;
  String _provider = 'AI';
  TripWeatherData? _weather;
  List<PackingItem> _items = const [];
  List<bool> _checked = const [];

  @override
  void initState() {
    super.initState();
    _loadPackingList();
  }

  Future<void> _loadPackingList() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      TripWeatherData? weather;
      try {
        weather = await _weatherService.fetchTripWeather(
          location: widget.trip.location,
          tripDate: widget.trip.startDate,
        );
      } catch (_) {
        weather = null;
      }

      final generated = await _aiPackingService.generatePackingList(
        trip: widget.trip,
        weather: weather,
      );

      final items = generated.items
          .asMap()
          .entries
          .map(
            (entry) =>
                PackingItem(label: entry.value, isEssential: entry.key < 4),
          )
          .toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _provider = generated.provider;
        _weather = weather;
        _items = items;
        _checked = List<bool>.filled(items.length, false);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final essentialCount = _items.where((item) => item.isEssential).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F7),
      appBar: AppBar(title: const Text('AI Packing List')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(12),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F5A2E).withAlpha(18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.backpack_outlined,
                      color: Color(0xFF1F5A2E),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.tripTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${trip.location} · ${trip.startDate.day}/${trip.startDate.month}/${trip.startDate.year}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$essentialCount essentials prepared by $_provider',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: const Color(0xFF1F5A2E),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (_weather != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  'Weather at ${trip.location}: ${_weather!.condition}, ${_weather!.temperatureC.toStringAsFixed(0)}°C, humidity ${_weather!.humidity}%, wind ${_weather!.windSpeedKmh.toStringAsFixed(0)} km/h',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: 18),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Unable to generate packing list.',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: _loadPackingList,
                            child: const Text('Try again'),
                          ),
                        ],
                      ),
                    )
                  : _items.isEmpty
                  ? Center(
                      child: Text(
                        'No packing items yet.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    )
                  : ListView.separated(
                      itemCount: _items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return PackingItemTile(
                          item: item,
                          checked: _checked[index],
                          onChanged: (value) {
                            setState(() {
                              _checked[index] = value ?? false;
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
