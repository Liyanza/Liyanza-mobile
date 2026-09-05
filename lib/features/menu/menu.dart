import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  // ===========================================================
  // DATA
  // ===========================================================

  static final List<MenuItem> _items = [
    MenuItem(
      title: 'Campagnes',
      icon: Icons.campaign_outlined,
      color: AppColors.green,
    ),
    MenuItem(
      title: 'Monitoring',
      icon: Icons.monitor_heart_outlined,
      color: AppColors.warning500,
    ),
    MenuItem(
      title: 'Recommand...',
      icon: Icons.lightbulb_outline,
      color: AppColors.blue,
    ),
    MenuItem(
      title: 'Equipes',
      icon: Icons.people_outline,
      color: AppColors.green,
    ),
    MenuItem(
      title: 'Rapports',
      icon: Icons.menu_book_outlined,
      color: AppColors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,

          children: [
            // =========================================
            // CARTE PRINCIPALE
            // =========================================
            Container(
              width: double.infinity,

              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),

              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  _buildSearchBar(),

                  const SizedBox(height: 20),

                  Text(
                    'Tous les univers Kiyanza',

                    style: TextStyle(
                      fontSize: AppSizes.text12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 14),

                  _buildGrid(),
                ],
              ),
            ),

            // =========================================
            // BOUTON FERMER
            // =========================================
            Positioned(
              bottom: -20,
              left: 0,
              right: 0,

              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },

                  child: Container(
                    width: 44,
                    height: 44,

                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // BARRE DE RECHERCHE
  // ===========================================================

  Widget _buildSearchBar() {
    return Container(
      height: 40,

      padding: const EdgeInsets.symmetric(horizontal: 12),

      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          const Icon(Icons.search, size: 18, color: AppColors.gray400),

          const SizedBox(width: 8),

          Text(
            'Rechercher',

            style: TextStyle(
              fontSize: AppSizes.text10,
              color: AppColors.gray400,
            ),
          ),

          const Spacer(),

          const Icon(Icons.tune, size: 16, color: AppColors.gray400),
        ],
      ),
    );
  }

  // ===========================================================
  // GRILLE DES UNIVERS
  // ===========================================================

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),

      itemCount: _items.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.35,
      ),

      itemBuilder: (context, index) {
        return _buildMenuCard(_items[index]);
      },
    );
  }

  // ===========================================================
  // CARTE UNIVERS
  // ===========================================================

  Widget _buildMenuCard(MenuItem item) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray100, width: 1),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Container(
            width: 32,
            height: 32,

            decoration: BoxDecoration(
              color: item.color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(item.icon, size: 18, color: item.color),
          ),

          const SizedBox(height: 8),

          Text(
            item.title,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// MODEL
// =============================================================

class MenuItem {
  final String title;
  final IconData icon;
  final Color color;

  MenuItem({required this.title, required this.icon, required this.color});
}
