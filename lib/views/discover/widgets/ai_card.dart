import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/routes/app_routes.dart';

class AiCard extends StatefulWidget {
  const AiCard({super.key});

  @override
  State<AiCard> createState() => _AiCardState();
}

class _AiCardState extends State<AiCard> with SingleTickerProviderStateMixin {
  bool isHover = false;
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => isHover = true),
        onTapUp: (_) => setState(() => isHover = false),
        onTapCancel: () => setState(() => isHover = false),
        onTap: () => Get.toNamed(AppRoutes.aiChat),
        child: AnimatedScale(
          scale: isHover ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF014D28),
                  Color(0xFF01803D),
                  Color(0xFF015C2F),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withAlpha(isHover ? 77 : 38),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF01803D).withAlpha(isHover ? 102 : 51),
                  blurRadius: isHover ? 25 : 15,
                  offset: Offset(0, isHover ? 12 : 6),
                  spreadRadius: isHover ? 2 : 0,
                ),
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: isHover ? 15 : 8,
                  offset: Offset(0, isHover ? 8 : 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Subtle shimmer effect
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withAlpha(13),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                            begin: Alignment(
                              -1.0 - _shimmerController.value * 2,
                              -1,
                            ),
                            end: Alignment(
                              1.0 - _shimmerController.value * 2,
                              1,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withAlpha(229),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withAlpha(77),
                                  blurRadius: isHover ? 12 : 8,
                                  spreadRadius: isHover ? 2 : 0,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: Color(0xFF014D28),
                              size: 24,
                            ),
                          ),
                          const Spacer(),
                          // Subtle arrow indicator
                          AnimatedOpacity(
                            opacity: isHover ? 1.0 : 0.6,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white.withAlpha(200),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        'AI Trail Guide',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withAlpha(100),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Ask about weather, gear or survival tips in real time.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withAlpha(200),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
