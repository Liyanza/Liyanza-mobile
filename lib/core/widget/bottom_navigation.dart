import 'package:flutter/material.dart';

import '../theme/kiyanza_colors.dart';
import '../theme/kiyanza_sizes.dart';

class KiyanzaBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const KiyanzaBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,

      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,

        children: [
          // =====================================================
          // BARRE BLANCHE
          // =====================================================

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 58,

            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,

                border: Border(
                  top: BorderSide(color: AppColors.gray200, width: 0.8),
                ),
              ),

              child: Row(
                children: [
                  _buildItem(
                    index: 0,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Accueil',
                  ),

                  _buildItem(
                    index: 1,
                    icon: Icons.campaign_outlined,
                    activeIcon: Icons.campaign,
                    label: 'Campagnes',
                  ),

                  // ============================================
                  // ESPACE POUR LE BOUTON CENTRAL
                  // ============================================
                  const SizedBox(width: 58),

                  _buildItem(
                    index: 3,
                    icon: Icons.auto_awesome_outlined,
                    activeIcon: Icons.auto_awesome,
                    label: 'Recom...',
                  ),

                  _buildItem(
                    index: 4,
                    icon: Icons.search_outlined,
                    activeIcon: Icons.search,
                    label: 'Recherche',
                  ),
                ],
              ),
            ),
          ),

          // =====================================================
          // BOUTON CENTRAL
          // =====================================================
          Positioned(
            top: -5,

            child: GestureDetector(
              onTap: () {
                onItemSelected(2);
              },

              child: Container(
                width: 52,
                height: 52,

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

                child: const Center(
                  child: Icon(
                    Icons.grid_view_rounded,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // ITEM
  // ===========================================================

  Widget _buildItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onTap: () {
          onItemSelected(index);
        },

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              isSelected ? activeIcon : icon,

              size: 21,

              color: isSelected ? AppColors.green : AppColors.gray600,
            ),

            const SizedBox(height: 3),

            Text(
              label,

              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                fontSize: AppSizes.text10,

                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,

                color: isSelected ? AppColors.green : AppColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
