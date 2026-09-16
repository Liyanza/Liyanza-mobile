import 'package:flutter/material.dart';

import '../widget/bottom_navigation.dart';

import '../../features/home/home.dart';
import '../../campagnes/campagne.dart';
import '../../simulation/recommendation.dart';
import 'app_drawer.dart';
import 'quick_actions_sheet.dart';
import '../theme/kiyanza_colors.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Nécessaire pour ouvrir le Drawer depuis n'importe où (bouton
  // central de la bottom nav, icônes ☰ des pages enfants) puisque
  // ces pages ont leur propre Scaffold imbriqué : un simple
  // `Scaffold.of(context).openDrawer()` depuis l'intérieur
  // ouvrirait leur Scaffold local, pas celui-ci.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      // =========================================================
      // ACCUEIL (index 0)
      // Même pattern que Campagnes : on transmet une fonction
      // qui permet à la page d'ouvrir le tiroir Menu.
      // =========================================================
      HomeScreen(onOpenMenu: _openDrawer),

      // =========================================================
      // CAMPAGNES (index 1)
      // =========================================================
      CampaignsScreen(onOpenMenu: _openDrawer),

      // =========================================================
      // RECOMMANDATIONS (index 2)
      // =========================================================
      const RecommendationsScreen(),

      // =========================================================
      // RECHERCHE (index 3)
      // Onglet référencé par KiyanzaBottomNavigation mais qui
      // n'avait pas encore de page associée -> placeholder en
      // attendant le véritable écran de recherche.
      // =========================================================
      const _SearchPlaceholder(),
    ];

    // NOTE : le Menu n'est plus un onglet de l'IndexedStack — sur
    // la maquette Figma c'est un tiroir (Drawer) qui glisse par
    // dessus l'écran actif. Voir _buildDrawer / KiyanzaDrawer.
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
  // OUVERTURE DU TIROIR MENU
  // =============================================================

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      drawer: KiyanzaDrawer(
        currentIndex: _currentIndex,
        onSelectTab: _onItemSelected,
      ),

      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: KiyanzaBottomNavigation(
        currentIndex: _currentIndex,
        onItemSelected: _onItemSelected,
        onCenterButtonTap: () => showQuickActionsSheet(context),
      ),
    );
  }
}

// =============================================================
// PLACEHOLDER — Recherche
// À remplacer par le véritable écran de recherche quand il
// sera prêt (même emplacement dans _pages : index 3).
// =============================================================
class _SearchPlaceholder extends StatelessWidget {
  const _SearchPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Text(
          'Recherche — à venir',
          style: TextStyle(color: AppColors.gray500),
        ),
      ),
    );
  }
}
