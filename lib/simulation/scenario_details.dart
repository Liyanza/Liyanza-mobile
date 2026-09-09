import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';
import 'recommendation.dart';

class ScenarioDetailsScreen extends StatefulWidget {
  const ScenarioDetailsScreen({super.key});

  @override
  State<ScenarioDetailsScreen> createState() => _ScenarioDetailsScreenState();
}

class _ScenarioDetailsScreenState extends State<ScenarioDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
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
            _buildHeader(context),

            _buildTabs(),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _ResumeTab(),
                  _ChannelsTab(),
                  _BudgetTab(),
                  _PerformanceTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: AppColors.black,
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                "Détail d'un scénario",

                style: TextStyle(
                  fontSize: AppSizes.text14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          const Icon(Icons.more_vert, color: AppColors.black),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,

      labelColor: AppColors.black,

      unselectedLabelColor: AppColors.gray400,

      indicatorColor: AppColors.blue,

      indicatorWeight: 2,

      labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),

      unselectedLabelStyle: const TextStyle(fontSize: 10),

      tabs: const [
        Tab(text: 'Résumé'),
        Tab(text: 'Canaux'),
        Tab(text: 'Budget'),
        Tab(text: 'Performances'),
      ],
    );
  }
}

// ============================================================
// ONGLET RÉSUMÉ
// ============================================================

class _ResumeTab extends StatelessWidget {
  const _ResumeTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ==================================================
          // TITRE
          // ==================================================

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Scénario A',

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: const Text(
                  'Recommandé',

                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          const Text(
            'Acquisition clients',

            style: TextStyle(fontSize: 11, color: AppColors.gray400),
          ),

          const SizedBox(height: 20),

          // ==================================================
          // BUDGET + PÉRIODE
          // ==================================================
          Row(
            children: const [
              Expanded(
                child: _InfoCard(title: 'Budget total', value: '100 000 FCFA'),
              ),

              SizedBox(width: 10),

              Expanded(
                child: _InfoCard(title: 'Période', value: '30 jours'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ==================================================
          // RÉSULTATS
          // ==================================================
          const Text(
            'Résultats estimés',

            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: const [
              Expanded(
                child: _ResultCard(value: '125K', label: 'Portée'),
              ),

              SizedBox(width: 8),

              Expanded(
                child: _ResultCard(value: '8,4K', label: 'Clics'),
              ),

              SizedBox(width: 8),

              Expanded(
                child: _ResultCard(value: '2,1K', label: 'Conversions'),
              ),

              SizedBox(width: 8),

              Expanded(
                child: _ResultCard(value: '3,2x', label: 'ROI'),
              ),
            ],
          ),

          const SizedBox(height: 26),

          // ==================================================
          // RÉPARTITION BUDGET
          // ==================================================
          Row(
            children: [
              const Text(
                'Répartition du budget',

                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),

              const Spacer(),

              Text(
                '100 000 FCFA',

                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const _BudgetDistributionCard(),
        ],
      ),
    );
  }
}

// ============================================================
// CARTE INFORMATION
// ============================================================

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(fontSize: 9, color: AppColors.gray400),
          ),

          const SizedBox(height: 8),

          Text(
            value,

            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CARTE RÉSULTAT
// ============================================================

class _ResultCard extends StatelessWidget {
  final String value;
  final String label;

  const _ResultCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),

      child: Column(
        children: [
          Text(
            value,

            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,

            textAlign: TextAlign.center,

            style: const TextStyle(fontSize: 7, color: AppColors.gray400),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ONGLET CANAUX
// ============================================================

class _ChannelsTab extends StatelessWidget {
  const _ChannelsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Canaux de diffusion',

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Répartition des performances par canal.',

            style: TextStyle(fontSize: 10, color: AppColors.gray400),
          ),

          const SizedBox(height: 20),

          const _ChannelPerformanceCard(
            icon: Icons.facebook,
            iconColor: AppColors.blue,

            title: 'Facebook Ads',
            budget: '60 000 FCFA',
            percentage: '60%',

            reach: '75K',
            clicks: '5,1K',
            conversions: '1,3K',
            roi: '3,6x',
          ),

          const SizedBox(height: 12),

          const _ChannelPerformanceCard(
            icon: Icons.camera_alt_outlined,
            iconColor: Color(0xFFE1306C),

            title: 'Instagram Ads',
            budget: '20 000 FCFA',
            percentage: '20%',

            reach: '30K',
            clicks: '2,0K',
            conversions: '0,5K',
            roi: '2,8x',
          ),

          const SizedBox(height: 12),

          const _ChannelPerformanceCard(
            icon: Icons.chat_outlined,
            iconColor: AppColors.green,

            title: 'WhatsApp Ads',
            budget: '20 000 FCFA',
            percentage: '20%',

            reach: '20K',
            clicks: '1,3K',
            conversions: '0,3K',
            roi: '2,4x',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CARTE PERFORMANCE CANAL
// ============================================================

class _ChannelPerformanceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;

  final String title;
  final String budget;
  final String percentage;

  final String reach;
  final String clicks;
  final String conversions;
  final String roi;

  const _ChannelPerformanceCard({
    required this.icon,
    required this.iconColor,

    required this.title,
    required this.budget,
    required this.percentage,

    required this.reach,
    required this.clicks,
    required this.conversions,
    required this.roi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,

                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(9),
                ),

                child: Icon(icon, size: 17, color: iconColor),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      budget,

                      style: const TextStyle(
                        fontSize: 8,
                        color: AppColors.gray400,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Text(
                  percentage,

                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _ChannelStat(value: reach, label: 'Portée'),
              ),

              Expanded(
                child: _ChannelStat(value: clicks, label: 'Clics'),
              ),

              Expanded(
                child: _ChannelStat(value: conversions, label: 'Conv.'),
              ),

              Expanded(
                child: _ChannelStat(value: roi, label: 'ROI'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChannelStat extends StatelessWidget {
  final String value;
  final String label;

  const _ChannelStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,

          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,

          style: const TextStyle(fontSize: 7, color: AppColors.gray400),
        ),
      ],
    );
  }
}

// ============================================================
// ONGLET BUDGET
// ============================================================

class _BudgetTab extends StatelessWidget {
  const _BudgetTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Budget total',

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 12),

          _buildTotalBudgetCard(),

          const SizedBox(height: 24),

          const Text(
            'Répartition du budget',

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 14),

          const _BudgetDistributionCard(),

          const SizedBox(height: 24),

          const Text(
            'Évolution du budget',

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 14),

          const _BudgetEvolutionCard(),

          const SizedBox(height: 24),

          const Text(
            'Détail par canal',

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 12),

          const _BudgetChannelCard(
            icon: Icons.facebook,
            iconColor: AppColors.blue,
            channelName: 'Facebook Ads',
            amount: '60 000 FCFA',
            percentage: '60%',
          ),

          const SizedBox(height: 10),

          const _BudgetChannelCard(
            icon: Icons.camera_alt_outlined,
            iconColor: Color(0xFFE1306C),
            channelName: 'Instagram Ads',
            amount: '20 000 FCFA',
            percentage: '20%',
          ),

          const SizedBox(height: 10),

          const _BudgetChannelCard(
            icon: Icons.chat_outlined,
            iconColor: AppColors.green,
            channelName: 'WhatsApp Ads',
            amount: '20 000 FCFA',
            percentage: '20%',
          ),
        ],
      ),
    );
  }

  Widget _buildTotalBudgetCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(16),
      ),

      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            'Budget prévu',

            style: TextStyle(fontSize: 11, color: Colors.white70),
          ),

          SizedBox(height: 8),

          Text(
            '100 000 FCFA',

            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),

          SizedBox(height: 6),

          Text(
            'Sur une période de 30 jours',

            style: TextStyle(fontSize: 10, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CARTE RÉPARTITION BUDGET
// ============================================================

class _BudgetDistributionCard extends StatelessWidget {
  const _BudgetDistributionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),

      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 120,
                height: 120,

                child: BudgetDonutChart(),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  children: const [
                    _BudgetLegendItem(
                      color: AppColors.blue,
                      name: 'Facebook Ads',
                      percentage: '60%',
                      amount: '60 000 FCFA',
                    ),

                    SizedBox(height: 14),

                    _BudgetLegendItem(
                      color: Color(0xFFE1306C),
                      name: 'Instagram Ads',
                      percentage: '20%',
                      amount: '20 000 FCFA',
                    ),

                    SizedBox(height: 14),

                    _BudgetLegendItem(
                      color: AppColors.green,
                      name: 'WhatsApp Ads',
                      percentage: '20%',
                      amount: '20 000 FCFA',
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                flex: 6,

                child: Container(
                  height: 6,

                  decoration: const BoxDecoration(
                    color: AppColors.blue,

                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 2,

                child: Container(height: 6, color: const Color(0xFFE1306C)),
              ),

              Expanded(
                flex: 2,

                child: Container(
                  height: 6,

                  decoration: const BoxDecoration(
                    color: AppColors.green,

                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LÉGENDE BUDGET
// ============================================================

class _BudgetLegendItem extends StatelessWidget {
  final Color color;
  final String name;
  final String percentage;
  final String amount;

  const _BudgetLegendItem({
    required this.color,
    required this.name,
    required this.percentage,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,

          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                name,

                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                amount,

                style: const TextStyle(fontSize: 7, color: AppColors.gray400),
              ),
            ],
          ),
        ),

        Text(
          percentage,

          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// CARTE BUDGET PAR CANAL
// ============================================================

class _BudgetChannelCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;

  final String channelName;
  final String amount;
  final String percentage;

  const _BudgetChannelCard({
    required this.icon,
    required this.iconColor,
    required this.channelName,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),

      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(icon, color: iconColor, size: 19),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  channelName,

                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  amount,

                  style: const TextStyle(fontSize: 9, color: AppColors.gray400),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),

            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              percentage,

              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// GRAPHIQUE ÉVOLUTION BUDGET
// ============================================================

class _BudgetEvolutionCard extends StatelessWidget {
  const _BudgetEvolutionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),

      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 130,

            child: CustomPaint(painter: BudgetChartPainter()),
          ),

          const SizedBox(height: 8),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                'S1',
                style: TextStyle(fontSize: 9, color: AppColors.gray400),
              ),

              Text(
                'S2',
                style: TextStyle(fontSize: 9, color: AppColors.gray400),
              ),

              Text(
                'S3',
                style: TextStyle(fontSize: 9, color: AppColors.gray400),
              ),

              Text(
                'S4',
                style: TextStyle(fontSize: 9, color: AppColors.gray400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BudgetChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFEDEDED)
      ..strokeWidth = 1;

    for (int i = 1; i < 4; i++) {
      final y = size.height * i / 4;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final linePaint = Paint()
      ..color = AppColors.green
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()..color = AppColors.green;

    final path = Path();

    final points = [
      Offset(0, size.height * 0.85),

      Offset(size.width * 0.33, size.height * 0.60),

      Offset(size.width * 0.66, size.height * 0.35),

      Offset(size.width, size.height * 0.12),
    ];

    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, linePaint);

    for (final point in points) {
      canvas.drawCircle(point, 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// ONGLET PERFORMANCES
// ============================================================

class _PerformanceTab extends StatelessWidget {
  const _PerformanceTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ==================================================
          // GRAPHIQUE
          // ==================================================

          const Text(
            'Performances dans le temps',

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 14),

          const _PerformanceChartCard(),

          const SizedBox(height: 24),

          // ==================================================
          // INDICATEURS
          // ==================================================
          const Text(
            'Indicateurs clés',

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: const [
              Expanded(
                child: _PerformanceMetricCard(
                  title: 'CPC moyen',
                  value: '120 FCFA',
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: _PerformanceMetricCard(
                  title: 'CPA estimé',
                  value: '476 FCFA',
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: const [
              Expanded(
                child: _PerformanceMetricCard(
                  title: 'Taux de conv.',
                  value: '2,1%',
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: _PerformanceMetricCard(title: 'ROI', value: '3,2x'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ==================================================
          // RECOMMANDATION IA
          // ==================================================
          const Text(
            'Recommandation IA',

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 12),

          _AiRecommendationCard(
            onViewRecommendations: () {
              // Action
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CARTE GRAPHIQUE PERFORMANCE
// ============================================================

class _PerformanceChartCard extends StatelessWidget {
  const _PerformanceChartCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),

      child: Column(
        children: [
          const Row(
            children: [
              _ChartLegend(color: AppColors.blue, text: 'Portée'),

              SizedBox(width: 12),

              _ChartLegend(color: AppColors.green, text: 'Clics'),

              SizedBox(width: 12),

              _ChartLegend(color: Color(0xFFE1306C), text: 'Conversions'),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 140,

            child: CustomPaint(painter: _PerformanceChartPainter()),
          ),

          const SizedBox(height: 8),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                'S1',
                style: TextStyle(fontSize: 9, color: AppColors.gray400),
              ),

              Text(
                'S2',
                style: TextStyle(fontSize: 9, color: AppColors.gray400),
              ),

              Text(
                'S3',
                style: TextStyle(fontSize: 9, color: AppColors.gray400),
              ),

              Text(
                'S4',
                style: TextStyle(fontSize: 9, color: AppColors.gray400),
              ),

              Text(
                'S5',
                style: TextStyle(fontSize: 9, color: AppColors.gray400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LÉGENDE GRAPHIQUE
// ============================================================

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String text;

  const _ChartLegend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,

          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: 5),

        Text(
          text,

          style: const TextStyle(fontSize: 8, color: AppColors.gray400),
        ),
      ],
    );
  }
}

// ============================================================
// PAINTER PERFORMANCE
// ============================================================

class _PerformanceChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFEDEDED)
      ..strokeWidth = 1;

    for (int i = 1; i < 4; i++) {
      final y = size.height * i / 4;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    _drawLine(canvas, size, [
      Offset(0, size.height * 0.72),

      Offset(size.width * 0.25, size.height * 0.55),

      Offset(size.width * 0.50, size.height * 0.38),

      Offset(size.width * 0.75, size.height * 0.24),

      Offset(size.width, size.height * 0.10),
    ], AppColors.blue);

    _drawLine(canvas, size, [
      Offset(0, size.height * 0.85),

      Offset(size.width * 0.25, size.height * 0.73),

      Offset(size.width * 0.50, size.height * 0.60),

      Offset(size.width * 0.75, size.height * 0.48),

      Offset(size.width, size.height * 0.35),
    ], AppColors.green);

    _drawLine(canvas, size, [
      Offset(0, size.height * 0.94),

      Offset(size.width * 0.25, size.height * 0.87),

      Offset(size.width * 0.50, size.height * 0.78),

      Offset(size.width * 0.75, size.height * 0.70),

      Offset(size.width, size.height * 0.62),
    ], const Color(0xFFE1306C));
  }

  void _drawLine(Canvas canvas, Size size, List<Offset> points, Color color) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, linePaint);

    for (final point in points) {
      canvas.drawCircle(point, 2.5, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// CARTE INDICATEUR PERFORMANCE
// ============================================================

class _PerformanceMetricCard extends StatelessWidget {
  final String title;
  final String value;

  const _PerformanceMetricCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(fontSize: 9, color: AppColors.gray400),
          ),

          const SizedBox(height: 8),

          Text(
            value,

            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// RECOMMANDATION IA
// ============================================================

class _AiRecommendationCard extends StatelessWidget {
  final VoidCallback onViewRecommendations;

  const _AiRecommendationCard({required this.onViewRecommendations});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFF4FAF6),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: AppColors.green.withOpacity(0.25)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,

                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.green,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Analyse de Kiyanza IA',

                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),

                    SizedBox(height: 3),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.green,
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 42,

            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecommendationsScreen(),
                  ),
                );
              },

              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.green,

                side: const BorderSide(color: AppColors.green),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),

              child: const Text(
                'Voir les recommandations',

                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DONUT CHART
// ============================================================

class BudgetDonutChart extends StatelessWidget {
  const BudgetDonutChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DonutPainter());
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 2 - 14;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final facebookPaint = Paint()
      ..color = AppColors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    final instagramPaint = Paint()
      ..color = const Color(0xFFE1306C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    final whatsappPaint = Paint()
      ..color = AppColors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    // 60 %
    canvas.drawArc(rect, -1.57, 3.77, false, facebookPaint);

    // 20 %
    canvas.drawArc(rect, 2.20, 1.25, false, instagramPaint);

    // 20 %
    canvas.drawArc(rect, 3.45, 1.25, false, whatsappPaint);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: '100 000\nFCFA',

        style: TextStyle(
          color: AppColors.black,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),

      textAlign: TextAlign.center,

      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    textPainter.paint(
      canvas,

      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
