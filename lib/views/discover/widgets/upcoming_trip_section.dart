import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/controllers/trip/trip_controller.dart';
import 'package:trailmate/models/Trip/trip_models.dart';
import 'package:trailmate/views/discover/widgets/new_trip_card.dart';
import 'package:trailmate/views/discover/widgets/trip_card.dart';

class UpcomingTripSection extends StatelessWidget {
  UpcomingTripSection({super.key});

  final TripController controller = Get.find<TripController>();

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    return SizedBox(
      height: 310,
      child: StreamBuilder<List<TripModels>>(
        stream: controller.userTripsStream,
        builder: (context, snapshot) {
          final trips = snapshot.data ?? <TripModels>[];
          final upcomingTrips = trips.where((trip) {
            final startDateOnly = DateTime(
              trip.startDate.year,
              trip.startDate.month,
              trip.startDate.day,
            );
            final endDateOnly = DateTime(
              trip.endDate.year,
              trip.endDate.month,
              trip.endDate.day,
            );

            final hasNotStarted =
                startDateOnly.isAtSameMomentAs(todayStart) ||
                startDateOnly.isAfter(todayStart);
            final notExpired =
                endDateOnly.isAtSameMomentAs(todayStart) ||
                endDateOnly.isAfter(todayStart);

            return hasNotStarted && notExpired;
          }).toList()..sort((a, b) => a.startDate.compareTo(b.startDate));

          final limitedTrips = upcomingTrips.take(2).toList();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: limitedTrips.length + 1,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemBuilder: (context, index) {
              if (index == limitedTrips.length) {
                return const NewTripCard();
              }
              return TripCard(trip: limitedTrips[index]);
            },
          );
        },
      ),
    );
  }
}
