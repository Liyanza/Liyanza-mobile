import 'package:flutter/material.dart';

import '../core/theme/kiyanza_colors.dart';

class ConversationHistoryScreen extends StatelessWidget {
  const ConversationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            _buildSearchBar(),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                children: [
                  const SizedBox(height: 14),

                  _buildSectionTitle('AUJOURD’HUI'),

                  _buildConversation(
                    title: 'Analyse la performance de ma campagne Facebook...',
                    tags: ['Analyse', 'Facebook'],
                    time: '14:32',
                    messages: '8 messages',
                  ),

                  _buildConversation(
                    title: 'Quel budget pour plus de conversions',
                    tags: ['Budget', 'Optimisation'],
                    time: '09:15',
                    messages: '6 messages',
                  ),

                  const SizedBox(height: 12),

                  _buildSectionTitle('HIER'),

                  _buildConversation(
                    title: 'Crée un scénario pour une campagne de notoriété',
                    tags: ['Scénario', 'Notoriété'],
                    time: '18:44',
                    messages: '11 messages',
                  ),

                  _buildConversation(
                    title:
                        'Quel est le meilleur moment pour publier sur TikTok ?',
                    tags: ['TikTok', 'Conseil'],
                    time: '11:20',
                    messages: '4 messages',
                  ),

                  const SizedBox(height: 12),

                  _buildSectionTitle('LUNDI 26 AOÛT'),

                  _buildConversation(
                    title: 'Donne-moi des recommandations pour améliorer...',
                    tags: ['Recommandations'],
                    time: '16:05',
                    messages: '9 messages',
                  ),

                  _buildConversation(
                    title: 'Comment calculer le ROI d’une campagne WhatsApp ?',
                    tags: ['ROI', 'WhatsApp'],
                    time: '10:33',
                    messages: '5 messages',
                  ),

                  const SizedBox(height: 12),

                  _buildSectionTitle('VENDREDI 23 AOÛT'),

                  _buildConversation(
                    title: 'Crée un plan marketing pour le lancement Facebook',
                    tags: ['Stratégie', 'Lancement'],
                    time: '09:50',
                    messages: '7 messages',
                  ),

                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      'Les anciennes conversations seront supprimées dans 30 jours',

                      textAlign: TextAlign.center,

                      style: TextStyle(fontSize: 10, color: Color(0xFFE76F6F)),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

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

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              'Historique des conversations',

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Container(
        height: 42,

        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F7),

          borderRadius: BorderRadius.circular(12),
        ),

        child: const TextField(
          decoration: InputDecoration(
            border: InputBorder.none,

            prefixIcon: Icon(Icons.search, size: 18, color: AppColors.gray400),

            hintText: 'Rechercher dans vos conversations...',

            hintStyle: TextStyle(fontSize: 10, color: AppColors.gray400),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),

      child: Text(
        title,

        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: AppColors.gray400,
        ),
      ),
    );
  }

  // ============================================================
  // CONVERSATION ITEM
  // ============================================================

  Widget _buildConversation({
    required String title,
    required List<String> tags,
    required String time,
    required String messages,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 38,
            height: 38,

            decoration: const BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
            ),

            child: const Center(
              child: Text(
                'K',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    const Text(
                      'Kiyanza IA',

                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      time,

                      style: const TextStyle(
                        fontSize: 8,
                        color: AppColors.gray400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  title,

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.gray500,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    ...tags.map(
                      (tag) => Padding(
                        padding: const EdgeInsets.only(right: 5),

                        child: _buildTag(tag),
                      ),
                    ),

                    const Spacer(),

                    Text(
                      messages,

                      style: const TextStyle(
                        fontSize: 8,
                        color: AppColors.gray400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TAG
  // ============================================================

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),

      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),

        borderRadius: BorderRadius.circular(8),
      ),

      child: Text(
        text,

        style: const TextStyle(fontSize: 7.5, color: AppColors.gray500),
      ),
    );
  }
}
