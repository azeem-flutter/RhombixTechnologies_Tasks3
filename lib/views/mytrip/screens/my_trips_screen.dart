import 'package:flutter/material.dart';
import 'package:trailmate/models/Trip/trip_model.dart';
import 'package:trailmate/views/mytrip/widgets/my_trip_card.dart';

class MyTripsScreen extends StatelessWidget {
  final List<TripModel> trips;

  const MyTripsScreen({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F7),
      appBar: AppBar(title: const Text('My Trips'), centerTitle: true),
      body: trips.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(18),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.map_outlined,
                      size: 44,
                      color: Color(0xFF1F5A2E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No trips found',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Start planning your next adventure.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              itemCount: trips.length,
              separatorBuilder: (context, index) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                return MyTripCard(trip: trips[index]);
              },
            ),
    );
  }
}
