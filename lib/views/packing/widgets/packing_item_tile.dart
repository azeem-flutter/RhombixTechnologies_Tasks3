import 'package:flutter/material.dart';
import 'package:trailmate/models/Trip/trip_model.dart';

class PackingItemTile extends StatelessWidget {
  final PackingItem item;
  final bool checked;
  final ValueChanged<bool?> onChanged;

  const PackingItemTile({
    super.key,
    required this.item,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      decoration: checked ? TextDecoration.lineThrough : TextDecoration.none,
      color: checked ? Colors.grey.shade500 : const Color(0xFF1B1F2A),
      fontWeight: FontWeight.w600,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: checked,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            activeColor: const Color(0xFF1F5A2E),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(item.label, style: textStyle)),
          if (item.isEssential)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1F5A2E).withAlpha(18),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Essential',
                style: TextStyle(
                  color: Color(0xFF1F5A2E),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
