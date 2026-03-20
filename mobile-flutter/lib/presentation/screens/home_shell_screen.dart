import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/navigation/home_tab.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/presentation/screens/calendar/calendar_screen.dart';
import 'package:mongtory_diary/presentation/screens/diary/diary_home_screen.dart';
import 'package:mongtory_diary/presentation/screens/profile/profile_screen.dart';

class HomeShellScreen extends ConsumerWidget {
  const HomeShellScreen({super.key});

  static const _pages = [
    DiaryHomeScreen(),
    CalendarScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(homeTabControllerProvider);
    final selectedIndex = HomeTab.values.indexOf(selectedTab);

    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref
              .read(homeTabControllerProvider.notifier)
              .select(HomeTab.values[index]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: '일기',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: '캘린더',
          ),
          NavigationDestination(
            icon: Icon(Icons.face_outlined),
            selectedIcon: Icon(Icons.face),
            label: '몽토리',
          ),
        ],
      ),
    );
  }
}
