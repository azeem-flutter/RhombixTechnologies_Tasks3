import 'package:flutter/material.dart';

class AiCard extends StatefulWidget {
  const AiCard({super.key});

  @override
  State<AiCard> createState() => _AiCardState();
}

class _AiCardState extends State<AiCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Handle card tap, e.g., navigate to AI Trail Guide details
        },
        child: Transform.scale(
          scale: isHover ? 1.03 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 1, 61, 3),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(
                    isHover ? 80 : 51,
                  ), // 80 = 0.31 * 255, 51 = 0.2 * 255
                  blurRadius: isHover ? 25 : 10,
                  offset: Offset(0, isHover ? 12 : 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star_border_outlined,
                      color: isHover ? Colors.black : Colors.black,
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AI Trail Guide',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ask about weather, gear or survival tips in real time.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
