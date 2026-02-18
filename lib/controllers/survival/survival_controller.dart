// lib/controllers/survival/survival_controller.dart

import 'package:flutter/foundation.dart';

import '../../models/survival/survival_tip_model.dart';

class SurvivalController extends ChangeNotifier {
  final List<String> categories = const [
    'Weather',
    'Wildlife',
    'First Aid',
    'Fire',
    'Navigation',
    'Food',
  ];

  final List<SurvivalTipModel> _allTips = const [
    SurvivalTipModel(
      id: '1',
      title: 'Build an Emergency Rain Shelter',
      description:
          'Use a tarp, cord, and nearby trees to create fast overhead protection from heavy rain and wind exposure.',
      category: 'Weather',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1473448912268-2022ce9509d8?q=80&w=1200&auto=format&fit=crop',
      videoUrl:
          'https://res.cloudinary.com/demo/video/upload/v1692791917/samples/sea-turtle.mp4',
    ),
    SurvivalTipModel(
      id: '2',
      title: 'Snake Encounter Safety',
      description:
          'Stay calm, step back slowly, and avoid sudden movement. Learn what to do if a snake blocks your trail.',
      category: 'Wildlife',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13?q=80&w=1200&auto=format&fit=crop',
      videoUrl:
          'https://res.cloudinary.com/demo/video/upload/v1692791918/samples/elephants.mp4',
    ),
    SurvivalTipModel(
      id: '3',
      title: 'Treat Minor Bleeding',
      description:
          'Apply direct pressure, elevate if possible, and secure a clean dressing to control bleeding quickly.',
      category: 'First Aid',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1530026186672-2cd00ffc50fe?q=80&w=1200&auto=format&fit=crop',
      videoUrl:
          'https://res.cloudinary.com/demo/video/upload/v1692791916/samples/cld-sample-video.mp4',
    ),
    SurvivalTipModel(
      id: '4',
      title: 'Start Fire in Wet Conditions',
      description:
          'Gather dry tinder from protected spots, build a raised base, and shield flame from wind for ignition.',
      category: 'Fire',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1514516430037-89f9e7f3c3fd?q=80&w=1200&auto=format&fit=crop',
      videoUrl:
          'https://res.cloudinary.com/demo/video/upload/v1692791917/samples/sea-turtle.mp4',
    ),
    SurvivalTipModel(
      id: '5',
      title: 'Navigate with Sun and Shadows',
      description:
          'Estimate cardinal directions using sun movement and simple shadow-stick methods when GPS is unavailable.',
      category: 'Navigation',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1502920514313-52581002a659?q=80&w=1200&auto=format&fit=crop',
      videoUrl:
          'https://res.cloudinary.com/demo/video/upload/v1692791918/samples/elephants.mp4',
    ),
    SurvivalTipModel(
      id: '6',
      title: 'Find Safe Wild Edibles',
      description:
          'Use strict identification rules and avoid unknown plants. Prioritize known berries and edible greens.',
      category: 'Food',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1490818387583-1baba5e638af?q=80&w=1200&auto=format&fit=crop',
      videoUrl:
          'https://res.cloudinary.com/demo/video/upload/v1692791916/samples/cld-sample-video.mp4',
    ),
    SurvivalTipModel(
      id: '7',
      title: 'Cold Exposure Warning Signs',
      description:
          'Recognize shivering, slurred speech, and confusion early to prevent hypothermia in low temperatures.',
      category: 'Weather',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?q=80&w=1200&auto=format&fit=crop',
      videoUrl:
          'https://res.cloudinary.com/demo/video/upload/v1692791917/samples/sea-turtle.mp4',
    ),
    SurvivalTipModel(
      id: '8',
      title: 'Purify Stream Water',
      description:
          'Filter particles first, then boil thoroughly or use purification tablets before drinking in the field.',
      category: 'Food',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1439066615861-d1af74d74000?q=80&w=1200&auto=format&fit=crop',
      videoUrl:
          'https://res.cloudinary.com/demo/video/upload/v1692791918/samples/elephants.mp4',
    ),
  ];

  String _searchQuery = '';
  String? _selectedCategory;

  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;

  List<SurvivalTipModel> get filteredTips {
    return _allTips
        .where((tip) {
          final categoryMatch =
              _selectedCategory == null || tip.category == _selectedCategory;
          final query = _searchQuery.trim().toLowerCase();
          final searchMatch =
              query.isEmpty ||
              tip.title.toLowerCase().contains(query) ||
              tip.description.toLowerCase().contains(query) ||
              tip.category.toLowerCase().contains(query);
          return categoryMatch && searchMatch;
        })
        .toList(growable: false);
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void toggleCategory(String category) {
    _selectedCategory = _selectedCategory == category ? null : category;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    notifyListeners();
  }
}
