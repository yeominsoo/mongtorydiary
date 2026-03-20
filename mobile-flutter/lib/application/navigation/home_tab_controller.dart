import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/navigation/home_tab.dart';

class HomeTabController extends StateNotifier<HomeTab> {
  HomeTabController() : super(HomeTab.diary);

  void select(HomeTab tab) {
    state = tab;
  }
}
