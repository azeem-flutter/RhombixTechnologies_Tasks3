import 'package:flutter/material.dart';
import 'package:trailmate/core/widgets/navigation_menu/nav_button.dart';
import 'package:trailmate/core/widgets/navigation_menu/nav_item.dart';

class NavGroup extends StatelessWidget {
  const NavGroup({
    super.key,
    required this.items,
    required this.activeColor,
    required this.inactiveColor,
    required this.selectedIndex,
    required this.onTap,
    required this.offset,
  });

  final List<NavItem> items;
  final Color activeColor;
  final Color? inactiveColor;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final int offset;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (i) {
          final index = i + offset;
          final isSelected = selectedIndex == index;

          return Expanded(
            child: NavButton(
              item: items[i],
              isSelected: isSelected,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => onTap(i),
            ),
          );
        }),
      ),
    );
  }
}
