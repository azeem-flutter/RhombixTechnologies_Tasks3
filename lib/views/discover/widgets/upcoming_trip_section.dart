import 'package:flutter/material.dart';
import 'package:trailmate/data/mock_trips.dart';
import 'package:trailmate/models/Trip/trip_model.dart';
import 'package:trailmate/views/discover/widgets/new_trip_card.dart';
import 'package:trailmate/views/discover/widgets/trip_card.dart';

class UpcomingTripSection extends StatelessWidget {
  UpcomingTripSection({super.key});

  final List<TripModel> trips = mockTrips.take(2).toList();

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
