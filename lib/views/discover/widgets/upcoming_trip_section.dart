import 'package:flutter/material.dart';
import 'package:trailmate/models/Trip/trip_model.dart';
import 'package:trailmate/views/discover/widgets/new_trip_card.dart';
import 'package:trailmate/views/discover/widgets/trip_card.dart';

class UpcomingTripSection extends StatelessWidget {
  final List<TripModel> trips = [
    TripModel(
      title: 'Glacier Lake Expedition',
      date: DateTime(2026, 10, 2),
      location: 'Montana, USA',
      imageUrl: 'assets/images/camp.jpg',
      isDraft: true,
    ),
    TripModel(
      title: 'BoneFire',
      date: DateTime(2026, 11, 15),
      location: 'Rocky Mountains, USA',
      imageUrl: 'assets/images/firecamp.jpg',
      isDraft: false,
    ),
  ];
  UpcomingTripSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trips.length + 1,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemBuilder: (context, index) {
          if (index == trips.length) {
            return const NewTripCard();
          }
          return TripCard(trip: trips[index]);
        },
      ),
    );
  }
}
