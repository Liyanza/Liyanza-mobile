import 'package:flutter/material.dart';

import '../widget/bottom_navigation.dart';

// IMPORTER TES PAGES
import '../../features/home/home.dart';
import '../../campagnes/campagne.dart';
import '../../simulation/recommendation.dart';

import '../../features/menu/menu.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      const HomeScreen(),
      const CampaignsScreen(),
      const MenuScreen(),
      const RecommendationsScreen(),
    ];
  }

  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: KiyanzaBottomNavigation(
        currentIndex: _currentIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
