import 'package:flutter/material.dart';
import 'package:trailmate/views/profile/widgets/profile_action_tile.dart';
import 'package:trailmate/views/profile/widgets/profile_stat_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1F5A2E),
                        width: 2,
                      ),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=300&q=80',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Avery Williams',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Trail Explorer · 186 km hiked',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1F5A2E), Color(0xFF2F7A44)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1F5A2E).withAlpha(32),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.eco_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Adventure readiness',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: 0.78,
                              minHeight: 8,
                              backgroundColor: Colors.white.withAlpha(40),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFD8F3DC),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '78% ready for your next trip',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your stats',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(
                    child: ProfileStatTile(
                      label: 'Trips',
                      value: '12',
                      icon: Icons.map_outlined,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ProfileStatTile(
                      label: 'Badges',
                      value: '7',
                      icon: Icons.emoji_events_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const ProfileStatTile(
                label: 'Gear items',
                value: '54',
                icon: Icons.backpack_outlined,
              ),
              const SizedBox(height: 24),
              Text(
                'Quick actions',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ProfileActionTile(
                icon: Icons.favorite_border,
                title: 'Saved locations',
                subtitle: 'Revisit favorite trails and campsites',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              ProfileActionTile(
                icon: Icons.notifications_none_outlined,
                title: 'Trip reminders',
                subtitle: 'Stay ready with custom alerts',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              ProfileActionTile(
                icon: Icons.shield_outlined,
                title: 'Safety checklist',
                subtitle: 'Review your essentials before leaving',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
