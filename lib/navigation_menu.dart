import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/core/widgets/navigation_menu/nav_group.dart';
import 'package:trailmate/core/widgets/navigation_menu/nav_item.dart';
import 'package:trailmate/core/widgets/navigation_menu/place_holder_page.dart';
import 'package:trailmate/views/discover/discover.dart';

class NavigationMenu extends StatelessWidget {
  NavigationMenu({super.key});

  final controller = Get.put(NavigationController());

  final List<Widget> pages = const [
    DiscoverScreen(),
    PlaceholderPage(title: 'My Trips'),
    PlaceholderPage(title: 'Create'),
    PlaceholderPage(title: 'book'),
    PlaceholderPage(title: 'Profile'),
  ];

  final List<NavItem> leftItems = const [
    NavItem(label: 'Discover', icon: Icons.explore_outlined),
    NavItem(label: 'My Trips', icon: Icons.map_outlined),
  ];

  final List<NavItem> rightItems = const [
    NavItem(label: 'book', icon: Icons.menu_book_outlined),
    NavItem(label: 'Profile', icon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF1F5A2E);
    final inactiveColor = Theme.of(
      context,
    ).textTheme.bodySmall?.color?.withAlpha(140);

    return Obx(() {
      final index = controller.selectedIndex.value;
      final isFabSelected = index == 2;

      return Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: pages[index],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.changeIndex(2),
          backgroundColor: activeColor,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          elevation: isFabSelected ? 6 : 2,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavGroup(
                items: leftItems,
                selectedIndex: index,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: (i) => controller.changeIndex(i),
                offset: 0,
              ),
              const SizedBox(width: 40),
              NavGroup(
                items: rightItems,
                selectedIndex: index,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: (i) => controller.changeIndex(i + 3),
                offset: 3,
              ),
            ],
          ),
        ),
      );
    });
  }
}

// Navigation Controller
class NavigationController extends GetxController {
  final selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
