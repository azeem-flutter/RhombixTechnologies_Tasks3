import 'package:trailmate/models/Trip/trip_model.dart';

final List<TripModel> mockTrips = [
  TripModel(
    title: 'Glacier Lake Expedition',
    date: DateTime(2026, 10, 2),
    location: 'Montana, USA',
    imageUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
    isDraft: true,
    packingList: const [
      PackingItem(label: '4-season tent', isEssential: true),
      PackingItem(label: 'Insulated sleeping bag', isEssential: true),
      PackingItem(label: 'Water filter bottle', isEssential: true),
      PackingItem(label: 'Thermal base layers'),
      PackingItem(label: 'Headlamp with extra batteries'),
      PackingItem(label: 'Trail snacks & energy bars'),
      PackingItem(label: 'First aid kit', isEssential: true),
    ],
  ),
  TripModel(
    title: 'Bonfire Camp Escape',
    date: DateTime(2026, 11, 15),
    location: 'Rocky Mountains, USA',
    imageUrl:
        'https://images.unsplash.com/photo-1470165517503-c2c9f96f88b7?auto=format&fit=crop&w=1200&q=80',
    packingList: const [
      PackingItem(label: 'Campfire starter kit', isEssential: true),
      PackingItem(label: 'Lightweight tarp', isEssential: true),
      PackingItem(label: 'Cooler & snacks'),
      PackingItem(label: 'Portable speaker'),
      PackingItem(label: 'Bug spray', isEssential: true),
      PackingItem(label: 'Folding chair'),
      PackingItem(label: 'Marshmallows & skewers'),
    ],
  ),
  TripModel(
    title: 'Coastal Sunrise Trek',
    date: DateTime(2026, 12, 4),
    location: 'Big Sur, USA',
    imageUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
    packingList: const [
      PackingItem(label: 'Windbreaker jacket', isEssential: true),
      PackingItem(label: 'Reusable water bottle', isEssential: true),
      PackingItem(label: 'Trail map & compass', isEssential: true),
      PackingItem(label: 'Sunscreen'),
      PackingItem(label: 'Camera or phone gimbal'),
      PackingItem(label: 'Electrolyte sachets'),
    ],
  ),
];
