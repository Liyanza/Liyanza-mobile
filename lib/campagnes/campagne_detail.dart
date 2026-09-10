import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';
import 'campagne.dart';

class CampaignDetailScreen extends StatefulWidget {
  final CampaignItem campaign;

  const CampaignDetailScreen({super.key, required this.campaign});

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // ===========================================================
  // DONNÉES DE DÉTAIL
  // ===========================================================
  //
  // NOTE : CampaignItem (liste des campagnes) ne porte pas encore
  // ces informations détaillées. En attendant un vrai modèle /
  // appel API, ces valeurs sont statiques et reprennent l'exemple
  // du Figma ("Promo Orange Money"). Remplace `_summary`, `_ageGroups`,
  // etc. par les vraies données de `widget.campaign` dès qu'elles
  // seront disponibles.

  static const String _campaignId = 'CMP-2024-0001';
  static const String _period = '12 Mai 2024 — 19 Mai 2024 (7 jours)';

  static final Map<String, String> _summary = {
    'Budget': '100 000 FCFA',
    'Dépensé': '68 000 FCFA',
    'Performance': '68%',
    'Portée': '25 400',
    'Prospects': '850',
    'Conversions': '120',
  };

  static final List<_MetricTile> _keyMetrics = [
    _MetricTile('Impressions', '45 200', '+12 % vs moy.', true),
    _MetricTile('Clics', '1 820', '+8 % vs moy.', true),
    _MetricTile('CTR', '4,0 %', '+0,4 pt vs moy.', true),
    _MetricTile('Coût / clic', '54 FCFA', '−6 % vs moy.', false),
  ];

  static final List<_ChannelShare> _channelShares = [
    _ChannelShare('Facebook', '530 prospects', 62),
    _ChannelShare('WhatsApp', '320 prospects', 38),
  ];

  static final List<_AgeGroup> _ageGroups = [
    _AgeGroup('18 – 24 ans', 35),
    _AgeGroup('25 – 34 ans', 45),
    _AgeGroup('35 – 44 ans', 15),
    _AgeGroup('45 ans et +', 5),
  ];

  static final List<_CityShare> _topCities = [
    _CityShare('Yaoundé', 45),
    _CityShare('Douala', 38),
    _CityShare('Bafoussam', 10),
    _CityShare('Autres', 7),
  ];

  static final List<_ActivityEvent> _activities = [
    _ActivityEvent(
      title: 'Campagne lancée',
      description: 'Budget initial : 100 000 FCFA',
      date: '12 Mai à 09:00',
      color: AppColors.blue,
    ),
    _ActivityEvent(
      title: 'Première impression enregistrée',
      description: 'Facebook · Yaoundé',
      date: '12 Mai à 14:30',
      color: AppColors.gray400,
    ),
    _ActivityEvent(
      title: '5 000 personnes atteintes',
      description: 'Objectif intermédiaire atteint',
      date: '13 Mai à 11:00',
      color: const Color(0xFF059669),
    ),
    _ActivityEvent(
      title: 'Ajustement automatique du budget',
      description: 'Réallocation vers Facebook (+8 %)',
      date: '14 Mai à 16:20',
      color: const Color(0xFF6B7280),
    ),
    _ActivityEvent(
      title: 'Rapport mi-parcours généré',
      description: "Performance : 52 % de l'objectif",
      date: '15 Mai à 09:00',
      color: AppColors.gray400,
    ),
    _ActivityEvent(
      title: "Dépassement de l'objectif",
      description: 'Performance au-dessus de 65 %',
      date: '16 Mai à 14:00',
      color: const Color(0xFF059669),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Column(
          children: [
            // =================================================
            // HEADER
            // =================================================

            _buildHeader(context),

            // =================================================
            // EN-TÊTE CAMPAGNE
            // =================================================
            _buildCampaignHeader(),

            // =================================================
            // ONGLETS
            // =================================================
            _buildTabBar(),

            // =================================================
            // CONTENU
            // =================================================
            Expanded(
              child: TabBarView(
                controller: _tabController,

                children: [
                  _buildApercuTab(),
                  _buildPerformanceTab(),
                  _buildAudienceTab(),
                  _buildActivitesTab(),
                ],
              ),
            ),

            // =================================================
            // BOUTON D'ACTION (change selon l'onglet)
            // =================================================
            _buildActionButton(context),
          ],
        ),
      ),

      // IMPORTANT :
      // PAS DE bottomNavigationBar ICI, gérée par MainNavigationScreen.
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
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),

            onPressed: () {
              Navigator.pop(context);
            },

            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: AppColors.black,
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'Détail campagne',

                style: TextStyle(
                  fontSize: AppSizes.text16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),

            onPressed: () {
              _showActionSheet(context);
            },

            icon: const Icon(Icons.more_vert, size: 18, color: AppColors.black),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // EN-TÊTE CAMPAGNE (icône + titre + statut + ID)
  // ===========================================================

  Widget _buildCampaignHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.gray100, width: 1)),
      ),

      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,

            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              widget.campaign.icon,
              size: 24,
              color: widget.campaign.iconColor,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.campaign.title,

                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF2AA147),
                          width: 1.2,
                        ),
                      ),

                      child: Text(
                        widget.campaign.status,

                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2AA147),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                Text(
                  widget.campaign.platform,

                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray400,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  'ID: $_campaignId',

                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFD1D5DC),
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
  // ONGLETS
  // ===========================================================

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.gray100, width: 1)),
      ),

      padding: const EdgeInsets.symmetric(horizontal: 20),

      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.black,
        indicatorWeight: 2,
        labelColor: AppColors.black,
        unselectedLabelColor: AppColors.gray400,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),

        labelStyle: const TextStyle(
          fontSize: AppSizes.text12,
          fontWeight: FontWeight.w600,
        ),

        unselectedLabelStyle: const TextStyle(
          fontSize: AppSizes.text12,
          fontWeight: FontWeight.w500,
        ),

        tabs: const [
          Tab(text: 'Aperçu'),
          Tab(text: 'Performance'),
          Tab(text: 'Audience'),
          Tab(text: 'Activités'),
        ],
      ),
    );
  }

  // ===========================================================
  // ONGLET APERÇU
  // ===========================================================

  Widget _buildApercuTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Résumé',

            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),

          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.1,

            children: _summary.entries.map((entry) {
              final bool isPerformance = entry.key == 'Performance';

              return _buildSummaryTile(
                label: entry.key,
                value: entry.value,
                showProgress: isPerformance,
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          const Text(
            'Période',

            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gray100, width: 1.2),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: const [
                Text(
                  _period,

                  style: TextStyle(fontSize: 12.5, color: Color(0xFF4A5565)),
                ),

                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.gray400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTile({
    required String label,
    required String value,
    bool showProgress = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray100, width: 1.2),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            label,

            style: const TextStyle(fontSize: 10.5, color: AppColors.gray400),
          ),

          const SizedBox(height: 4),

          Text(
            value,

            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          if (showProgress) ...[
            const SizedBox(height: 6),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: LinearProgressIndicator(
                value: widget.campaign.performance / 100,
                minHeight: 6,
                backgroundColor: AppColors.gray100,
                valueColor: const AlwaysStoppedAnimation(AppColors.blue),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================
  // ONGLET PERFORMANCE
  // ===========================================================

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Performance générale',

            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gray100, width: 1.2),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: const [
                    Text(
                      'Portée journalière',

                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A5565),
                      ),
                    ),

                    Text(
                      '7 jours',

                      style: TextStyle(fontSize: 11, color: AppColors.gray400),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                SizedBox(
                  height: 72,
                  width: double.infinity,

                  child: CustomPaint(painter: _MiniLineChartPainter()),
                ),

                const SizedBox(height: 8),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      'L',
                      style: TextStyle(fontSize: 10, color: AppColors.gray400),
                    ),
                    Text(
                      'Ma',
                      style: TextStyle(fontSize: 10, color: AppColors.gray400),
                    ),
                    Text(
                      'Me',
                      style: TextStyle(fontSize: 10, color: AppColors.gray400),
                    ),
                    Text(
                      'J',
                      style: TextStyle(fontSize: 10, color: AppColors.gray400),
                    ),
                    Text(
                      'V',
                      style: TextStyle(fontSize: 10, color: AppColors.gray400),
                    ),
                    Text(
                      'S',
                      style: TextStyle(fontSize: 10, color: AppColors.gray400),
                    ),
                    Text(
                      'D',
                      style: TextStyle(fontSize: 10, color: AppColors.gray400),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Métriques clés',

            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),

          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.65,

            children: _keyMetrics.map((metric) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gray100, width: 1.2),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      metric.label,

                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.gray400,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      metric.value,

                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      metric.delta,

                      style: TextStyle(
                        fontSize: 10,
                        color: metric.positive
                            ? const Color(0xFF059669)
                            : AppColors.gray500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          const Text(
            'Par canal',

            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gray100, width: 1.2),
            ),

            child: Column(
              children: List.generate(_channelShares.length, (index) {
                final channel = _channelShares[index];
                final bool isLast = index == _channelShares.length - 1;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(
                              color: AppColors.gray100,
                              width: 1.2,
                            ),
                          ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            channel.name,

                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                channel.detail,

                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.gray400,
                                ),
                              ),

                              const SizedBox(width: 8),

                              Text(
                                '${channel.percent}%',

                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),

                        child: LinearProgressIndicator(
                          value: channel.percent / 100,
                          minHeight: 6,
                          backgroundColor: AppColors.gray100,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // ONGLET AUDIENCE
  // ===========================================================

  Widget _buildAudienceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Tranche d'âge",

            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gray100, width: 1.2),
            ),

            child: Column(
              children: List.generate(_ageGroups.length, (index) {
                final group = _ageGroups[index];
                final bool isLast = index == _ageGroups.length - 1;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(
                              color: AppColors.gray100,
                              width: 1.2,
                            ),
                          ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            group.label,

                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF364153),
                            ),
                          ),

                          Text(
                            '${group.percent}%',

                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),

                        child: LinearProgressIndicator(
                          value: group.percent / 100,
                          minHeight: 6,
                          backgroundColor: AppColors.gray100,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Genre',

            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),

          const SizedBox(height: 12),

          _buildGenderCard(),

          const SizedBox(height: 20),

          const Text(
            'Top villes',

            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gray100, width: 1.2),
            ),

            child: Column(
              children: List.generate(_topCities.length, (index) {
                final city = _topCities[index];
                final bool isLast = index == _topCities.length - 1;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(
                              color: AppColors.gray100,
                              width: 1.2,
                            ),
                          ),
                  ),

                  child: Row(
                    children: [
                      SizedBox(
                        width: 76,

                        child: Text(
                          city.name,

                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF364153),
                          ),
                        ),
                      ),

                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),

                          child: LinearProgressIndicator(
                            value: city.percent / 100,
                            minHeight: 6,
                            backgroundColor: AppColors.gray100,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.blue,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      SizedBox(
                        width: 34,

                        child: Text(
                          '${city.percent}%',

                          textAlign: TextAlign.right,

                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF364153),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Appareils',

            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildDeviceTile(Icons.smartphone, '87%', 'Mobile'),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildDeviceTile(
                  Icons.desktop_windows_outlined,
                  '13%',
                  'Desktop',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray100, width: 1.2),
      ),

      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: SizedBox(
              height: 10,

              child: Row(
                children: const [
                  Expanded(flex: 58, child: ColoredBox(color: AppColors.blue)),
                  Expanded(
                    flex: 42,
                    child: ColoredBox(color: Color(0xFFD1D5DB)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Row(
                children: const [
                  _Dot(color: Color(0xFF1BB14A)),
                  SizedBox(width: 8),
                  Text(
                    'Hommes',
                    style: TextStyle(fontSize: 12.5, color: Color(0xFF364153)),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '58%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),

              Row(
                children: const [
                  _Dot(color: Color(0xFFFF6A00)),
                  SizedBox(width: 8),
                  Text(
                    'Femmes',
                    style: TextStyle(fontSize: 12.5, color: Color(0xFF364153)),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '42%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceTile(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),

      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray100, width: 1.2),
      ),

      child: Column(
        children: [
          Icon(icon, size: 22, color: AppColors.gray400),

          const SizedBox(height: 8),

          Text(
            value,

            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,

            style: const TextStyle(fontSize: 11, color: AppColors.gray400),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // ONGLET ACTIVITÉS
  // ===========================================================

  Widget _buildActivitesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Historique des activités',

            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),

          const SizedBox(height: 16),

          ...List.generate(_activities.length, (index) {
            final activity = _activities[index];
            final bool isLast = index == _activities.length - 1;

            return _buildActivityRow(activity, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildActivityRow(_ActivityEvent activity, bool isLast) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,

                  decoration: BoxDecoration(
                    color: activity.color,
                    shape: BoxShape.circle,
                  ),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin: const EdgeInsets.only(top: 6),
                      color: AppColors.gray100,
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    activity.title,

                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    activity.description,

                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF6A7282),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    activity.date,

                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.gray400,
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
  // BOUTON D'ACTION (change selon l'onglet actif)
  // ===========================================================

  Widget _buildActionButton(BuildContext context) {
    final labels = [
      'Voir la performance',
      'Exporter le rapport',
      'Audience complète',
      "Voir tout l'historique",
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

      child: SizedBox(
        width: double.infinity,
        height: 54,

        child: ElevatedButton(
          onPressed: () {
            // TODO: brancher l'action réelle pour chaque onglet
            if (_tabController.index != 1) {
              _tabController.animateTo(1);
            }
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),

            elevation: 0,
          ),

          child: Text(
            labels[_tabController.index],

            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // ACTION SHEET (menu "...")
  // ===========================================================

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),

      builder: (context) {
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
                    widget.campaign.title,

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              _actionSheetTile(
                icon: Icons.remove_red_eye_outlined,
                label: 'Voir les détails',
                onTap: () => Navigator.pop(context),
              ),

              _actionSheetTile(
                icon: Icons.edit_outlined,
                label: 'Modifier la campagne',
                onTap: () => Navigator.pop(context),
              ),

              _actionSheetTile(
                icon: Icons.copy_outlined,
                label: 'Dupliquer',
                onTap: () => Navigator.pop(context),
              ),

              _actionSheetTile(
                icon: Icons.archive_outlined,
                label: 'Archiver',
                onTap: () => Navigator.pop(context),
              ),

              _actionSheetTile(
                icon: Icons.delete_outline,
                label: 'Supprimer la campagne',
                labelColor: const Color(0xFFDC2626),
                iconBg: const Color(0xFFFEF2F2),
                onTap: () => Navigator.pop(context),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),

                child: SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),

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
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF364153),
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

  Widget _actionSheetTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color labelColor = AppColors.black,
    Color iconBg = const Color(0xFFF9FAFB),
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),

        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,

              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(icon, size: 16, color: labelColor),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                label,

                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// PETITE PUCE COLORÉE (légende)
// =============================================================

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// =============================================================
// MODELS
// =============================================================

class _MetricTile {
  final String label;
  final String value;
  final String delta;
  final bool positive;

  _MetricTile(this.label, this.value, this.delta, this.positive);
}

class _ChannelShare {
  final String name;
  final String detail;
  final int percent;

  _ChannelShare(this.name, this.detail, this.percent);
}

class _AgeGroup {
  final String label;
  final int percent;

  _AgeGroup(this.label, this.percent);
}

class _CityShare {
  final String name;
  final int percent;

  _CityShare(this.name, this.percent);
}

class _ActivityEvent {
  final String title;
  final String description;
  final String date;
  final Color color;

  _ActivityEvent({
    required this.title,
    required this.description,
    required this.date,
    required this.color,
  });
}

// =================================================================
// PAINTER — mini courbe de portée journalière
// =================================================================

class _MiniLineChartPainter extends CustomPainter {
  static const List<double> _values = [0.3, 0.42, 0.38, 0.55, 0.62, 0.7, 0.95];

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()..color = AppColors.black;

    final fillPaint = Paint()
      ..color = AppColors.blue.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final stepX = size.width / (_values.length - 1);

    final linePath = Path();
    final fillPath = Path();

    for (int i = 0; i < _values.length; i++) {
      final x = stepX * i;
      final y = size.height - (_values[i] * size.height);

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);

    for (int i = 0; i < _values.length; i++) {
      final x = stepX * i;
      final y = size.height - (_values[i] * size.height);
      canvas.drawCircle(Offset(x, y), 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MiniLineChartPainter oldDelegate) => false;
}
