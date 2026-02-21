// lib/views/trip_detail/trip_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:trailmate/models/Trip/trip_model.dart';
import 'package:trailmate/views/trip/widgets/itinerary_section.dart';
import 'package:trailmate/views/trip/widgets/packing_section.dart';
import 'package:trailmate/views/trip/widgets/trip_action_button.dart';
import 'package:trailmate/views/trip/widgets/trip_hero_image.dart';
import 'package:trailmate/views/trip/widgets/trip_info_section.dart';
import 'package:trailmate/views/trip/widgets/trip_participant.dart';
import 'package:trailmate/views/trip/widgets/weather_card_row.dart';

class TripDetailScreen extends StatefulWidget {
  final TripModel trip;

  const TripDetailScreen({super.key, required this.trip});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  List<String> activities = [
    'Start hiking at base camp - 6:00 AM',
    'Reach first checkpoint - 9:00 AM',
    'Lunch break at scenic viewpoint - 12:00 PM',
    'Continue to glacier lake - 2:00 PM',
    'Set up camp - 5:00 PM',
  ];

  void _addActivity(String activity) {
    setState(() {
      activities.add(activity);
    });
  }

  void _deleteActivity(int index) {
    setState(() {
      activities.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: CustomScrollView(
        slivers: [
          // Hero Image with back button
          TripHeroImage(imageUrl: widget.trip.imageUrl),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip Info (Title, Location, Date, Duration, Difficulty, Type)
                TripInfoSection(trip: widget.trip),

                const SizedBox(height: 24),

                // Weather Cards Row
                const WeatherCardsRow(
                  temperature: '24°C',
                  windSpeed: '12 km/h',
                  humidity: '65%',
                ),

                const SizedBox(height: 24),

                // Participants Section
                const TripParticipants(
                  participantAvatars: [
                    'https://i.pravatar.cc/150?img=1',
                    'https://i.pravatar.cc/150?img=2',
                    'https://i.pravatar.cc/150?img=3',
                  ],
                  totalParticipants: 5,
                ),

                const SizedBox(height: 28),

                // Action Buttons (removed Edit Trip)
                const TripActionButtons(),

                const SizedBox(height: 24),

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
