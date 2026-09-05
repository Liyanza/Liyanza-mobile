import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  int _selectedFilter = 1; // 'Actives' sélectionné par défaut (cf. maquette)

  final List<CampaignItem> _campaigns = [
    CampaignItem(
      title: 'Promo Orange Money',
      platform: 'Facebook',
      budget: 'Budget: 100 000 FCFA',
      performance: 68,
      status: 'Active',
      icon: Icons.facebook,
      iconColor: AppColors.blue,
    ),
    CampaignItem(
      title: 'Lancement Fibre',
      platform: 'TikTok',
      budget: 'Budget: 150 000 FCFA',
      performance: 72,
      status: 'Active',
      icon: Icons.music_note,
      iconColor: AppColors.black,
    ),
  ];

  // ===========================================================
  // FILTRAGE
  // ===========================================================

  List<CampaignItem> get _filteredCampaigns {
    // 0 = Toutes, 1 = Actives, 2 = Brouillons, 3 = Terminées
    if (_selectedFilter == 1) {
      return _campaigns
          .where((campaign) => campaign.status == 'Active')
          .toList();
    }

    if (_selectedFilter == 2) {
      return _campaigns
          .where((campaign) => campaign.status == 'Brouillon')
          .toList();
    }

    if (_selectedFilter == 3) {
      return _campaigns
          .where((campaign) => campaign.status == 'Terminée')
          .toList();
    }

    return _campaigns;
  }

  @override
  Widget build(BuildContext context) {
    final campaigns = _filteredCampaigns;

    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Column(
          children: [
            // =================================================
            // HEADER
            // =================================================

            _buildHeader(),

            // =================================================
            // RECHERCHE
            // =================================================
            _buildSearchBar(),

            // =================================================
            // FILTRES
            // =================================================
            _buildFilters(),

            // =================================================
            // LISTE DES CAMPAGNES
            // =================================================
            Expanded(
              child: campaigns.isEmpty
                  ? _buildEmptyState()
                  : _buildCampaignList(campaigns),
            ),

            // =================================================
            // BOUTON NOUVELLE CAMPAGNE
            // =================================================
            _buildNewCampaignButton(),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ===========================================================
  // HEADER
  // ===========================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),

      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },

            child: const Icon(Icons.menu, size: 22, color: AppColors.black),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'Campagnes',

                style: TextStyle(
                  fontSize: AppSizes.text16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          const Icon(Icons.search, size: 22, color: AppColors.black),
        ],
      ),
    );
  }

  // ===========================================================
  // BARRE DE RECHERCHE
  // ===========================================================

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),

      child: Container(
        height: 40,

        padding: const EdgeInsets.symmetric(horizontal: 14),

        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Row(
          children: [
            const Icon(Icons.search, size: 15, color: AppColors.gray400),

            const SizedBox(width: 8),

            Text(
              'Rechercher une campagne',

              style: TextStyle(
                fontSize: AppSizes.text14,
                color: AppColors.gray400,
              ),
            ),

            const Spacer(),

            const Icon(Icons.tune, size: 15, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // FILTRES (onglets soulignés)
  // ===========================================================

  Widget _buildFilters() {
    final filters = ['Toutes', 'Actives', 'Brouillons', 'Terminées'];

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.gray100, width: 1)),
      ),

      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Row(
        children: List.generate(filters.length, (index) {
          final bool selected = _selectedFilter == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = index;
              });
            },

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected ? AppColors.black : Colors.transparent,
                    width: 1.2,
                  ),
                ),
              ),

              child: Text(
                filters[index],

                style: TextStyle(
                  fontSize: AppSizes.text12,
                  fontWeight: FontWeight.w500,
                  color: selected ? AppColors.black : AppColors.gray400,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ===========================================================
  // LISTE
  // ===========================================================

  Widget _buildCampaignList(List<CampaignItem> campaigns) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      itemCount: campaigns.length,

      itemBuilder: (context, index) {
        return _buildCampaignCard(campaigns[index]);
      },
    );
  }

  // ===========================================================
  // CARTE CAMPAGNE
  // ===========================================================

  Widget _buildCampaignCard(CampaignItem campaign) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.gray100, width: 1)),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // Icône plateforme
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(campaign.icon, size: 22, color: campaign.iconColor),
          ),

          const SizedBox(width: 12),

          // Contenu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        campaign.title,

                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.gray100, width: 1),
                      ),

                      child: Text(
                        campaign.status,

                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gray500,
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    const Icon(
                      Icons.more_vert,
                      size: 16,
                      color: AppColors.gray400,
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                Text(
                  campaign.platform,

                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.gray400,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  campaign.budget,

                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.gray500,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Performance: ${campaign.performance}%',

                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.gray500,
                  ),
                ),

                const SizedBox(height: 4),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),

                  child: LinearProgressIndicator(
                    value: campaign.performance / 100,
                    minHeight: 6,
                    backgroundColor: AppColors.gray100,
                    valueColor: const AlwaysStoppedAnimation(AppColors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // EMPTY STATE
  // ===========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: AppColors.gray100,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.campaign_outlined,
              color: AppColors.gray400,
              size: 22,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Aucune campagne pour l’instant',

            style: TextStyle(fontSize: 9, color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // BOUTON NOUVELLE CAMPAGNE
  // ===========================================================

  Widget _buildNewCampaignButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),

      child: SizedBox(
        width: double.infinity,
        height: 54,

        child: ElevatedButton(
          onPressed: () {
            // TODO: navigation vers la création de campagne
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),

            elevation: 0,
          ),

          child: const Text(
            '+ Nouvelle campagne',

            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // BOTTOM NAV
  // ===========================================================

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.gray100, width: 1)),
      ),

      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          _buildNavItem(Icons.home_outlined, 'Accueil', false),
          _buildNavItem(Icons.campaign, 'Campagnes', true),

          // Bouton central
          Transform.translate(
            offset: const Offset(0, -14),

            child: GestureDetector(
              onTap: () {},

              child: Container(
                width: 48,
                height: 48,

                decoration: const BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.dashboard_outlined,
                  size: 22,
                  color: AppColors.white,
                ),
              ),
            ),
          ),

          _buildNavItem(Icons.lightbulb_outline, 'Rcom..', false),
          _buildNavItem(Icons.search, 'Rechercher', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool selected) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        Icon(
          icon,
          size: 20,
          color: selected ? AppColors.black : AppColors.gray400,
        ),

        const SizedBox(height: 2),

        Text(
          label,

          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.black : AppColors.gray400,
          ),
        ),
      ],
    );
  }
}

// =============================================================
// MODEL
// =============================================================

class CampaignItem {
  final String title;
  final String platform;
  final String budget;
  final int performance;
  final String status;
  final IconData icon;
  final Color iconColor;

  CampaignItem({
    required this.title,
    required this.platform,
    required this.budget,
    required this.performance,
    required this.status,
    required this.icon,
    required this.iconColor,
  });
}
