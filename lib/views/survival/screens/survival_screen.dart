// lib/ui/survival/screens/survival_screen.dart

import 'package:flutter/material.dart';

import '../../../controllers/survival/survival_controller.dart';
import 'survival_detail_screen.dart';
import '../widgets/category_chip.dart';
import '../widgets/search_field.dart';
import '../widgets/survival_card.dart';

class SurvivalScreen extends StatefulWidget {
  const SurvivalScreen({super.key});

  @override
  State<SurvivalScreen> createState() => _SurvivalScreenState();
}

class _SurvivalScreenState extends State<SurvivalScreen> {
  late final SurvivalController _controller;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _controller = SurvivalController();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Survival Handbook')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F6EA), Color(0xFFF6FCF7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final tips = _controller.filteredTips;
              final width = MediaQuery.of(context).size.width;
              final isCompact = width < 380;
              final crossAxisCount = isCompact ? 1 : 2;
              final itemWidth =
                  (width - 16 * 2 - (crossAxisCount - 1) * 12) / crossAxisCount;
              final itemHeight = isCompact
                  ? itemWidth * 0.72
                  : itemWidth * 1.28;
              final childAspectRatio = itemWidth / itemHeight;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                    child: SearchField(
                      controller: _searchController,
                      onChanged: _controller.setSearchQuery,
                    ),
                  ),
                  SizedBox(
                    height: 52,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: _controller.categories.length,
                      itemBuilder: (context, index) {
                        final category = _controller.categories[index];
                        return CategoryChip(
                          label: category,
                          selected: _controller.selectedCategory == category,
                          onTap: () => _controller.toggleCategory(category),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: tips.isEmpty
                        ? Center(
                            child: Text(
                              'No guides found.',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: childAspectRatio,
                                ),
                            itemCount: tips.length,
                            itemBuilder: (context, index) {
                              final tip = tips[index];
                              final heroTag = 'survival_tip_${tip.id}';

                              return TweenAnimationBuilder<double>(
                                duration: Duration(
                                  milliseconds: 240 + (index * 60),
                                ),
                                tween: Tween(begin: 0.94, end: 1),
                                curve: Curves.easeOutBack,
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value.clamp(0, 1),
                                    child: Transform.scale(
                                      scale: value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: SurvivalCard(
                                  tip: tip,
                                  heroTag: heroTag,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => SurvivalDetailScreen(
                                          tip: tip,
                                          heroTag: heroTag,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
