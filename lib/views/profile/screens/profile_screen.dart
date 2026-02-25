import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/controllers/auth/auth_controller.dart';
import 'package:trailmate/controllers/trip/favorite_trip_controller.dart';
import 'package:trailmate/controllers/trip/trip_controller.dart';
import 'package:trailmate/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.instance;
    final tripController = Get.find<TripController>();
    final favoritesController = Get.find<FavoriteTripController>();
    final user = authController.currentUser.value;
    final displayName = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : (user?.email?.split('@').first ?? 'TrailMate Explorer');
    final initials = displayName
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F6),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F5A2E),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF5F8F6),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            // ── Avatar ────────────────────────────────────────────
            CircleAvatar(
              radius: 46,
              backgroundColor: const Color(0xFF1F5A2E),
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Name ──────────────────────────────────────────────
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 32),

            // ── Stats ─────────────────────────────────────────────
            StreamBuilder(
              stream: tripController.userTripsStream,
              builder: (context, snapshot) {
                final trips = snapshot.data ?? const [];
                return Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.map_outlined,
                        value: trips.length.toString(),
                        label: 'Trips',
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Obx(
                        () => _StatCard(
                          icon: Icons.favorite_border_rounded,
                          value: favoritesController.favoriteTrips.length
                              .toString(),
                          label: 'Saved',
                          onTap: () => Get.toNamed(AppRoutes.favorites),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const Spacer(),

            // ── Sign Out ──────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => authController.signOut(),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade400,
                  side: BorderSide(color: Colors.red.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat Card
// ─────────────────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1F5A2E).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF1F5A2E), size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
