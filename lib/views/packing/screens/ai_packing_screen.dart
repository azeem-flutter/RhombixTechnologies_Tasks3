import 'package:flutter/material.dart';
import 'package:trailmate/models/Trip/trip_model.dart';
import 'package:trailmate/views/packing/widgets/packing_item_tile.dart';

class AiPackingScreen extends StatefulWidget {
  final TripModel trip;

  const AiPackingScreen({super.key, required this.trip});

  @override
  State<AiPackingScreen> createState() => _AiPackingScreenState();
}

class _AiPackingScreenState extends State<AiPackingScreen> {
  late List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _checked = List<bool>.filled(widget.trip.packingList.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final essentialCount = trip.packingList
        .where((item) => item.isEssential)
        .toList()
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F7),
      appBar: AppBar(title: const Text('AI Packing List')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(12),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F5A2E).withAlpha(18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.backpack_outlined,
                      color: Color(0xFF1F5A2E),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${trip.location} · ${trip.date.day}/${trip.date.month}/${trip.date.year}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$essentialCount essentials prepared by AI',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: const Color(0xFF1F5A2E),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: trip.packingList.isEmpty
                  ? Center(
                      child: Text(
                        'No packing items yet.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    )
                  : ListView.separated(
                      itemCount: trip.packingList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = trip.packingList[index];
                        return PackingItemTile(
                          item: item,
                          checked: _checked[index],
                          onChanged: (value) {
                            setState(() {
                              _checked[index] = value ?? false;
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
