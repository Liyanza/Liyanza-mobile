import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';
import 'campagne_detail.dart';
import 'nouvellecampagne.dart';

class CampaignsScreen extends StatefulWidget {
  final VoidCallback onOpenMenu;

  const CampaignsScreen({super.key, required this.onOpenMenu});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  int _selectedFilter = 1;

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

  // ===========================================================
  // BUILD
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    final campaigns = _filteredCampaigns;

    return Scaffold(
      backgroundColor: AppColors.white,

      // =========================================================
      // DRAWER
      // =========================================================
      drawer: _buildDrawer(context),

      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            _buildHeader(context),

            // RECHERCHE
            _buildSearchBar(),

            // FILTRES
            _buildFilters(),

            // LISTE
            Expanded(
              child: campaigns.isEmpty
                  ? _buildEmptyState()
                  : _buildCampaignList(campaigns),
            ),

            // BOUTON NOUVELLE CAMPAGNE
            _buildNewCampaignButton(),
          ],
        ),
      ),

      // IMPORTANT :
      // PAS DE bottomNavigationBar ICI.
      //
      // La Bottom Navigation est déjà gérée par
      // MainNavigationScreen.
    );
  }

  // ===========================================================
  // HEADER
  // ===========================================================

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),

      child: Row(
        children: [
          // =====================================================
          // BOUTON MENU
          // =====================================================

          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),

            onPressed: () {
              widget.onOpenMenu();
            },

            icon: const Icon(Icons.menu, size: 22, color: AppColors.black),
          ),

          // =====================================================
          // TITRE
          // =====================================================
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

          // =====================================================
          // RECHERCHE
          // =====================================================
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),

            onPressed: () {
              // Tu pourras ajouter une action plus tard.
            },

            icon: const Icon(Icons.search, size: 22, color: AppColors.black),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // DRAWER / MENU LATERAL
  // ===========================================================

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,

      child: SafeArea(
        child: Column(
          children: [
            // ===================================================
            // EN-TÊTE
            // ===================================================

            Padding(
              padding: const EdgeInsets.all(20),

              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,

                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),

                    child: const Center(
                      child: Text(
                        'K',

                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    'Kiyanza',

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // ===================================================
            // ACCUEIL
            // ===================================================
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Accueil'),

              onTap: () {
                Navigator.pop(context);
              },
            ),

            // ===================================================
            // CAMPAGNES
            // ===================================================
            ListTile(
              leading: const Icon(Icons.campaign, color: AppColors.green),

              title: const Text(
                'Campagnes',

                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),

              onTap: () {
                Navigator.pop(context);
              },
            ),

            // ===================================================
            // MENU
            // ===================================================
            ListTile(
              leading: const Icon(Icons.grid_view_outlined),
              title: const Text('Menu'),

              onTap: () {
                Navigator.pop(context);
              },
            ),

            // ===================================================
            // RECOMMANDATIONS
            // ===================================================
            ListTile(
              leading: const Icon(Icons.auto_awesome_outlined),
              title: const Text('Recommandations'),

              onTap: () {
                Navigator.pop(context);
              },
            ),

            // ===================================================
            // RECHERCHE
            // ===================================================
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Recherche'),

              onTap: () {
                Navigator.pop(context);
              },
            ),

            const Spacer(),

            const Divider(),

            // ===================================================
            // PARAMÈTRES
            // ===================================================
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Paramètres'),

              onTap: () {
                Navigator.pop(context);
              },
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
  // FILTRES
  // ===========================================================

  Widget _buildFilters() {
    final filters = ['Toutes', 'Actives', 'Brouillons', 'Terminées'];

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.gray100, width: 1)),
      ),

      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),

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
      ),
    );
  }

  // ===========================================================
  // LISTE DES CAMPAGNES
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CampaignDetailScreen(campaign: campaign),
          ),
        );
      },

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),

        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.gray100, width: 1),
          ),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =====================================================
            // ICÔNE PLATEFORME
            // =====================================================

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

            // =====================================================
            // INFORMATIONS
            // =====================================================
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

                          border: Border.all(
                            color: AppColors.gray100,
                            width: 1,
                          ),
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

                      GestureDetector(
                        onTap: () =>
                            _showCampaignActionSheet(context, campaign),

                        child: const Icon(
                          Icons.more_vert,
                          size: 16,
                          color: AppColors.gray400,
                        ),
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
      ),
    );
  }

  // ===========================================================
  // ACTION SHEET ("...")
  // ===========================================================
  //
  // Ouvert par le bouton "..." de chaque carte. "Voir les détails"
  // mène au même CampaignDetailScreen que le tap sur la carte —
  // garde les deux chemins pour ne rien casser côté navigation.

  void _showCampaignActionSheet(BuildContext context, CampaignItem campaign) {
    showModalBottomSheet(
      context: context,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),

      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              const SizedBox(height: 12),

              Container(
                width: 40,
                height: 4,

                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),

                child: Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    campaign.title,

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.remove_red_eye_outlined),
                title: const Text('Voir les détails'),

                onTap: () {
                  Navigator.pop(sheetContext);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CampaignDetailScreen(campaign: campaign),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Modifier la campagne'),

                onTap: () {
                  Navigator.pop(sheetContext);
                  // TODO: navigation vers l'écran d'édition
                },
              ),

              ListTile(
                leading: const Icon(Icons.copy_outlined),
                title: const Text('Dupliquer'),

                onTap: () {
                  Navigator.pop(sheetContext);
                  // TODO: dupliquer la campagne
                },
              ),

              ListTile(
                leading: const Icon(Icons.archive_outlined),
                title: const Text('Archiver'),

                onTap: () {
                  Navigator.pop(sheetContext);
                  // TODO: archiver la campagne
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFDC2626),
                ),

                title: const Text(
                  'Supprimer la campagne',

                  style: TextStyle(color: Color(0xFFDC2626)),
                ),

                onTap: () {
                  Navigator.pop(sheetContext);
                  // TODO: confirmer puis supprimer la campagne
                },
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),

                child: SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(sheetContext),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gray100,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),

                    child: const Text(
                      'Annuler',

                      style: TextStyle(
                        color: AppColors.gray500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

            style: TextStyle(fontSize: 12, color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // NOUVELLE CAMPAGNE
  // ===========================================================

  Widget _buildNewCampaignButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),

      child: SizedBox(
        width: double.infinity,
        height: 54,

        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewCampaignScreen(),
              ),
            );
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
