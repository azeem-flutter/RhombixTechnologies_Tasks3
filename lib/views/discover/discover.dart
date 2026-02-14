import 'package:flutter/material.dart';
import 'package:trailmate/core/widgets/title/heading_title.dart';
import 'package:trailmate/views/discover/widgets/ai_card.dart';
import 'package:trailmate/views/discover/widgets/upcoming_trip_section.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning, Explorer',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color.fromARGB(255, 107, 107, 107),
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Ready for adventure?',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none_outlined),
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              HeadingTitle(title: 'Upcoming Trips', onTap: () {}),
              const SizedBox(height: 20),

              // Placeholder for upcoming trips list
              UpcomingTripSection(),
              const SizedBox(height: 24),
              const AiCard(),
            ],
          ),
        ),
      ),
    );
  }
}
