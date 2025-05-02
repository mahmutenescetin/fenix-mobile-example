import 'package:flutter/material.dart';
import 'package:fenix_mobile_example/core/base/base_viewmodel.dart';
import 'package:fenix_mobile_example/presentation/features/home/view/home_view.dart';
import 'package:fenix_mobile_example/presentation/features/favorites/view/favorites_view.dart';

class MainViewModel extends BaseViewModel {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeView(),
    const FavoritesView(),
  ];

  int get currentIndex => _currentIndex;
  Widget get currentPage => _pages[_currentIndex];

  void onTabTapped(int index) {
    _currentIndex = index;
    notifyListeners();
  }
} 