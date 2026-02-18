// lib/ui/survival/widgets/category_chip.dart

import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const _icons = <String, IconData>{
    'All': Icons.apps_rounded,
    'Weather': Icons.cloud_rounded,
    'Wildlife': Icons.pets_rounded,
    'First Aid': Icons.medical_services_rounded,
    'Fire': Icons.local_fire_department_rounded,
    'Navigation': Icons.explore_rounded,
    'Food & Water': Icons.water_drop_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final icon = _icons[label];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: selected ? const Color(0xFF1B4332) : Colors.white,
        elevation: selected ? 3 : 0,
        borderRadius: BorderRadius.circular(999),
        shadowColor: selected
            ? const Color(0xFF1B4332).withValues(alpha: 0.25)
            : Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: icon != null ? 12 : 16,
              vertical: 10,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 14,
                    color: selected ? Colors.white : const Color(0xFF2D6A4F),
                  ),
                  const SizedBox(width: 5),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : const Color(0xFF1B4332),
                    letterSpacing: 0.1,
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
