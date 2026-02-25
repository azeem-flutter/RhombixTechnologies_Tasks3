import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/controllers/trip/trip_controller.dart';
import 'package:trailmate/models/Trip/trip_models.dart';
import 'package:trailmate/views/mytrip/widgets/my_trip_card.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  Future<void> _confirmDeleteTrip(
    BuildContext context,
    TripController controller,
    TripModels trip,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete trip?'),
          content: Text(
            'Are you sure you want to delete "${trip.tripTitle}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await controller.deleteTrip(trip);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TripController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F7),
      appBar: AppBar(title: const Text('My Trips'), centerTitle: true),
      body: StreamBuilder<List<TripModels>>(
        stream: controller.userTripsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final trips = snapshot.data ?? <TripModels>[];
          if (trips.isEmpty) {
            return Center(
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
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            itemCount: trips.length,
            separatorBuilder: (context, index) => const SizedBox(height: 18),
            itemBuilder: (context, index) {
              return Obx(() {
                final trip = trips[index];
                return MyTripCard(
                  trip: trip,
                  isDeleting: controller.isDeletingTrip(trip.id),
                  onDelete: () => _confirmDeleteTrip(context, controller, trip),
                );
              });
            },
          );
        },
      ),
    );
  }
}
