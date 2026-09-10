import 'package:flutter/material.dart';

import '../widget/bottom_navigation.dart';

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

      // =========================================================
      // CAMPAGNES
      // On transmet une fonction qui permet à la page Campagnes
      // d'ouvrir le Menu.
      // =========================================================
      CampaignsScreen(
        onOpenMenu: () {
          _onItemSelected(2);
        },
      ),

      // =========================================================
      // MENU
      // =========================================================
      const MenuScreen(),

      // =========================================================
      // RECOMMANDATIONS
      // =========================================================
      const RecommendationsScreen(),
    ];
  }

  // =============================================================
  // CHANGEMENT D'ONGLET
  // =============================================================

  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // =============================================================
  // BUILD
  // =============================================================

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
