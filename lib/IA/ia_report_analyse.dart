import 'package:flutter/material.dart';

import '../core/theme/kiyanza_colors.dart';

//import '../core/theme/kiyanza_sizes.dart';

class AiReportAnalysisScreen extends StatefulWidget {
  const AiReportAnalysisScreen({super.key});

  @override
  State<AiReportAnalysisScreen> createState() => _AiReportAnalysisScreenState();
}

class _AiReportAnalysisScreenState extends State<AiReportAnalysisScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
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

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserQuestion(),

                    const SizedBox(height: 14),

                    _buildAiMessage(
                      'Voici votre analyse complète. '
                      'J’ai identifié les principaux indicateurs '
                      'et les opportunités d’amélioration.',
                    ),

                    const SizedBox(height: 12),

                    _buildReportButton(),

                    const SizedBox(height: 12),

                    _buildAnalysisMessage(),

                    const SizedBox(height: 10),

                    _buildReportAnalysisCard(),

                    const SizedBox(height: 14),

                    _buildAiMessage(
                      'Souhaitez-vous approfondir l’une de ces pistes ?',
                    ),

                    const SizedBox(height: 10),

                    _buildQuickActions(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            _buildSuggestionBar(),

            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // HEADER
  // ===========================================================

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 12),

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F3F5), width: 1)),
      ),

      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: Container(
              width: 34,
              height: 34,

              decoration: const BoxDecoration(
                color: Color(0xFFF7F8FA),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: AppColors.black,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Container(
            width: 34,
            height: 34,

            decoration: const BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
            ),

            child: const Center(
              child: Text(
                'K',

                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),

          const SizedBox(width: 9),

          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Kiyanza IA',

                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),

                SizedBox(height: 2),

                Row(
                  children: [
                    Icon(Icons.circle, size: 6, color: AppColors.green),

                    SizedBox(width: 4),

                    Text(
                      'Votre copilote marketing',

                      style: TextStyle(fontSize: 9, color: AppColors.gray400),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            width: 32,
            height: 32,

            decoration: const BoxDecoration(
              color: Color(0xFFF7F8FA),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.info_outline,
              size: 17,
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // QUESTION UTILISATEUR
  // ===========================================================

  Widget _buildUserQuestion() {
    return Align(
      alignment: Alignment.centerRight,

      child: Container(
        constraints: const BoxConstraints(maxWidth: 240),

        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),

        decoration: BoxDecoration(
          color: AppColors.blue,

          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
        ),

        child: const Text(
          'Analyse mon rapport PDF et donne-moi les principaux résultats.',

          style: TextStyle(color: AppColors.white, fontSize: 12, height: 1.35),
        ),
      ),
    );
  }

  // ===========================================================
  // AVATAR IA
  // ===========================================================

  Widget _buildAiAvatar() {
    return Container(
      width: 28,
      height: 28,

      decoration: const BoxDecoration(
        color: AppColors.blue,
        shape: BoxShape.circle,
      ),

      child: const Center(
        child: Text(
          'K',

          style: TextStyle(
            color: AppColors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // MESSAGE IA
  // ===========================================================

  Widget _buildAiMessage(String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        _buildAiAvatar(),

        const SizedBox(width: 8),

        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F8),

              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),

            child: Text(
              message,

              style: const TextStyle(
                fontSize: 11,
                color: AppColors.gray500,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // BOUTON RAPPORT ANALYSÉ
  // ===========================================================

  Widget _buildReportButton() {
    return Row(
      children: [
        const SizedBox(width: 36),

        Expanded(
          child: GestureDetector(
            onTap: () {
              // TODO:
              // ouvrir le détail du rapport analysé
            },

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),

              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(10),

                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: const Row(
                children: [
                  Icon(
                    Icons.description_outlined,
                    color: AppColors.white,
                    size: 18,
                  ),

                  SizedBox(width: 9),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Rapport analysé',

                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 2),

                        Text(
                          'PDF • 2,8 MB',

                          style: TextStyle(
                            color: Color(0xFFDCE9FF),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(Icons.chevron_right, color: AppColors.white, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // MESSAGE ANALYSE
  // ===========================================================

  Widget _buildAnalysisMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        _buildAiAvatar(),

        const SizedBox(width: 8),

        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F8),

              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),

            child: const Text(
              'J’ai analysé votre rapport PDF. '
              'Voici les principaux résultats détectés.',

              style: TextStyle(
                fontSize: 11,
                color: AppColors.gray500,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // CARTE ANALYSE DU RAPPORT
  // ===========================================================

  Widget _buildReportAnalysisCard() {
    return Container(
      margin: const EdgeInsets.only(left: 36),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFE7EAF0)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        children: [
          _buildAnalysisHeader(),

          const Divider(height: 1, color: Color(0xFFEFF1F4)),

          _buildAnalysisProgress(),

          const Divider(height: 1, color: Color(0xFFEFF1F4)),

          _buildResultItem(
            icon: Icons.trending_down,
            title: 'Portée Facebook',
            description: 'Performance inférieure de 25%',
            value: '-25%',
            valueColor: const Color(0xFFE15241),
          ),

          const Divider(height: 1, color: Color(0xFFF0F1F3)),

          _buildResultItem(
            icon: Icons.calendar_today_outlined,
            title: 'Période',
            description: 'Durée de campagne optimale',
            value: '14 jours',
            valueColor: AppColors.green,
          ),

          const Divider(height: 1, color: Color(0xFFF0F1F3)),

          _buildResultItem(
            icon: Icons.lightbulb_outline,
            title: 'Taux de conversion',
            description: '2,3% — objectif à améliorer',
            value: '2,3%',
            valueColor: const Color(0xFFE15241),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // HEADER ANALYSE
  // ===========================================================

  Widget _buildAnalysisHeader() {
    return const Padding(
      padding: EdgeInsets.all(13),

      child: Row(
        children: [
          Expanded(
            child: Text(
              'Analyse du rapport PDF',

              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ),

          Text(
            '3 insights',

            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD97706),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // PROGRESSION
  // ===========================================================

  Widget _buildAnalysisProgress() {
    return Padding(
      padding: const EdgeInsets.all(13),

      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                size: 16,
                color: Color(0xFFD97706),
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  'Analyse terminée',

                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),

              const Text(
                '3 min',

                style: TextStyle(fontSize: 9, color: AppColors.gray400),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Stack(
            children: [
              Container(
                height: 5,

                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              FractionallySizedBox(
                widthFactor: 1,

                child: Container(
                  height: 5,

                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // RESULTAT
  // ===========================================================

  Widget _buildResultItem({
    required IconData icon,
    required String title,
    required String description,
    required String value,
    required Color valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),

      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,

            decoration: BoxDecoration(
              color: const Color(0xFFF6F7F9),
              borderRadius: BorderRadius.circular(8),
            ),

            child: Icon(icon, size: 15, color: AppColors.gray500),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  description,

                  style: const TextStyle(
                    fontSize: 8.5,
                    color: AppColors.gray400,
                  ),
                ),
              ],
            ),
          ),

          Text(
            value,

            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // ACTIONS RAPIDES
  // ===========================================================

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.only(left: 36),

      child: Wrap(
        spacing: 8,
        runSpacing: 8,

        children: [
          _buildActionChip(
            label: 'Voir les recommandations',
            icon: Icons.lightbulb_outline,

            onTap: () {
              // TODO:
              // Navigation vers les recommandations
            },
          ),

          _buildActionChip(
            label: 'Exporter le rapport',
            icon: Icons.file_download_outlined,

            onTap: () {
              _showExportOptions();
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // BOUTON ACTION
  // ===========================================================

  Widget _buildActionChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        decoration: BoxDecoration(
          color: AppColors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: const Color(0xFFDCE1E8)),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(icon, size: 13, color: AppColors.blue),

            const SizedBox(width: 5),

            Text(
              label,

              style: const TextStyle(
                fontSize: 9,
                color: AppColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // SUGGESTIONS BAS
  // ===========================================================

  Widget _buildSuggestionBar() {
    return SizedBox(
      height: 42,

      child: ListView(
        scrollDirection: Axis.horizontal,

        padding: const EdgeInsets.symmetric(horizontal: 12),

        children: [
          _buildSuggestion('Analyser une campagne'),
          _buildSuggestion('Créer un scénario'),
          _buildSuggestion('Idées de campagne'),
        ],
      ),
    );
  }

  Widget _buildSuggestion(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 7, top: 5, bottom: 5),

      padding: const EdgeInsets.symmetric(horizontal: 11),

      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: const Color(0xFFE8EBEF)),
      ),

      child: Center(
        child: Text(
          text,

          style: const TextStyle(fontSize: 8.5, color: AppColors.gray500),
        ),
      ),
    );
  }

  // ===========================================================
  // CHAMP DE MESSAGE
  // ===========================================================

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),

      decoration: const BoxDecoration(
        color: AppColors.white,

        border: Border(top: BorderSide(color: Color(0xFFF0F1F3))),
      ),

      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F8),
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.attach_file,
              size: 18,
              color: AppColors.gray500,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Container(
              height: 40,

              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F8),
                borderRadius: BorderRadius.circular(20),
              ),

              child: TextField(
                controller: _messageController,

                decoration: const InputDecoration(
                  hintText: 'Écrivez votre message...',

                  hintStyle: TextStyle(fontSize: 10, color: AppColors.gray400),

                  border: InputBorder.none,

                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          Container(
            width: 38,
            height: 38,

            decoration: const BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
            ),

            child: IconButton(
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  _messageController.clear();
                }
              },

              icon: const Icon(
                Icons.arrow_upward,
                size: 18,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // EXPORT OPTIONS
  // ===========================================================

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.transparent,

      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),

          decoration: const BoxDecoration(
            color: AppColors.white,

            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                width: 42,
                height: 4,

                decoration: BoxDecoration(
                  color: const Color(0xFFE1E4E8),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  'Exporter le rapport',

                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _buildExportOption(
                icon: Icons.picture_as_pdf_outlined,
                title: 'Rapport PDF',
                subtitle: 'Télécharger le rapport complet',
                color: const Color(0xFFF59E0B),
              ),

              _buildExportOption(
                icon: Icons.table_chart_outlined,
                title: 'Fichier Excel / CSV',
                subtitle: 'Exporter les données',
                color: AppColors.green,
              ),

              _buildExportOption(
                icon: Icons.image_outlined,
                title: 'Image / Capture d’écran',
                subtitle: 'Partager les résultats',
                color: AppColors.blue,
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F4F6),

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
            ],
          ),
        );
      },
    );
  }

  // ===========================================================
  // OPTION EXPORT
  // ===========================================================

  Widget _buildExportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),

      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFF0F1F3)),

          borderRadius: BorderRadius.circular(14),
        ),

        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(icon, color: color, size: 21),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,

                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.gray400,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }
}
