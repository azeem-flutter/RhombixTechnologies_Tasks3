// lib/views/trip_detail/trip_detail_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trailmate/controllers/auth/auth_controller.dart';
import 'package:trailmate/models/Trip/trip_models.dart';
import 'package:trailmate/services/trip_services.dart';
import 'package:trailmate/services/weather_service.dart';
import 'package:trailmate/views/trip/widgets/itinerary_section.dart';
import 'package:trailmate/views/trip/widgets/packing_section.dart';
import 'package:trailmate/views/trip/widgets/trip_hero_image.dart';
import 'package:trailmate/views/trip/widgets/trip_info_section.dart';
import 'package:trailmate/views/trip/widgets/trip_participant.dart';
import 'package:trailmate/views/trip/widgets/weather_card_row.dart';

class TripDetailScreen extends StatefulWidget {
  final TripModels trip;

  const TripDetailScreen({super.key, required this.trip});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  final TripServices _tripServices = TripServices();

  late List<String> activities;
  late Future<TripWeatherData> _weatherFuture;

  @override
  void initState() {
    super.initState();
    activities = List<String>.from(widget.trip.activities);
    _weatherFuture = WeatherService().fetchTripWeather(
      location: widget.trip.location,
      tripDate: widget.trip.startDate,
    );
  }

  Future<void> _persistActivities(List<String> previousActivities) async {
    final userId = AuthController.instance.currentUser.value?.uid;
    if (userId == null) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in required to save activities.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      await _tripServices.updateTrip(
        userId,
        widget.trip.copyWith(activities: activities),
      );
      widget.trip.activities = List<String>.from(activities);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        activities = previousActivities;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save activities. Change reverted.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _addActivity(String activity) {
    final previousActivities = List<String>.from(activities);
    setState(() {
      activities.add(activity);
    });
    _persistActivities(previousActivities);
  }

  void _deleteActivity(int index) {
    if (index < 0 || index >= activities.length) {
      return;
    }

    final previousActivities = List<String>.from(activities);
    setState(() {
      activities.removeAt(index);
    });
    _persistActivities(previousActivities);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: CustomScrollView(
        slivers: [
          // Hero Image with back button
          TripHeroImage(trip: widget.trip),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip Info (Title, Location, Date, Duration, Difficulty, Type)
                TripInfoSection(trip: widget.trip),

                const SizedBox(height: 24),

                // Weather Cards Row
                FutureBuilder<TripWeatherData>(
                  future: _weatherFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: LinearProgressIndicator(minHeight: 6),
                      );
                    }

                    if (snapshot.hasError) {
                      final errorText = snapshot.error.toString().replaceFirst(
                        'Exception: ',
                        '',
                      );
                      final helperText = kIsWeb
                          ? 'Web browser blocks some direct API calls (CORS). Run on Android/iOS/Windows, or use a backend proxy for weather requests.'
                          : 'Please verify OPENWEATHER_API_KEY and internet connectivity.';

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Text(
                            'Weather unavailable: $errorText\n\n$helperText',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(height: 1.4),
                          ),
                        ),
                      );
                    }

                    final weather = snapshot.data;
                    if (weather == null) {
                      return const SizedBox.shrink();
                    }

                    return WeatherCardsRow(
                      temperature:
                          '${weather.temperatureC.toStringAsFixed(0)}°C',
                      windSpeed:
                          '${weather.windSpeedKmh.toStringAsFixed(0)} km/h',
                      humidity: '${weather.humidity}%',
                      feelsLike: '${weather.feelsLikeC.toStringAsFixed(0)}°C',
                      pressure: '${weather.pressureHpa} hPa',
                      condition: weather.condition,
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Participants Section
                TripParticipants(
                  participantAvatars: const [
                    'https://i.pravatar.cc/150?img=1',
                    'https://i.pravatar.cc/150?img=2',
                    'https://i.pravatar.cc/150?img=3',
                  ],
                  totalParticipants: int.tryParse(widget.trip.members) ?? 1,
                ),

                const SizedBox(height: 28),

                PackingSection(trip: widget.trip),

                const SizedBox(height: 32),

                // Decorative Divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.grey.shade300,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Itinerary Section
                ItinerarySection(
                  activities: activities,
                  onAddActivity: _addActivity,
                  onDeleteActivity: _deleteActivity,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
