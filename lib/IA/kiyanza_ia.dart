import 'package:flutter/material.dart';

import '../core/theme/kiyanza_colors.dart';
import 'conversation_history.dart';

class KiyanzaAiScreen extends StatefulWidget {
  const KiyanzaAiScreen({super.key});

  @override
  State<KiyanzaAiScreen> createState() => _KiyanzaAiScreenState();
}

class _KiyanzaAiScreenState extends State<KiyanzaAiScreen> {
  final TextEditingController _messageController = TextEditingController();

  final List<_Message> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(text: text, isUser: true));
    });

    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;

      setState(() {
        _messages.add(
          _Message(
            text: 'Voici une analyse basée sur les données disponibles.',
            isUser: false,
          ),
        );
      });
    });
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
              child: _messages.isEmpty
                  ? _buildWelcomeScreen()
                  : _buildConversation(),
            ),

            _buildInputArea(),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F3F5))),
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

              decoration: BoxDecoration(
                color: const Color(0xFFF6F7F8),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 15,
                color: AppColors.black,
              ),
            ),
          ),

          const SizedBox(width: 12),

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
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Kiyanza IA',

                  style: TextStyle(
                    fontSize: 14,
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

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ConversationHistoryScreen(),
                ),
              );
            },

            child: Container(
              width: 34,
              height: 34,

              decoration: BoxDecoration(
                color: const Color(0xFFF6F7F8),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.history,
                size: 18,
                color: AppColors.gray500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WELCOME SCREEN
  // ============================================================

  Widget _buildWelcomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),

      child: Column(
        children: [
          const SizedBox(height: 10),

          Container(
            width: 64,
            height: 64,

            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(18),
            ),

            child: const Center(
              child: Text(
                'K',

                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Bonjour, Aristide 👋',

            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Comment puis-je vous aider aujourd’hui ?',

            textAlign: TextAlign.center,

            style: TextStyle(fontSize: 12, color: AppColors.gray500),
          ),

          const SizedBox(height: 28),

          _buildSuggestionRow(
            title1: 'Analyse ma campagne\nFacebook du mois',
            title2: 'Quel budget pour\natteindre 10 000 ventes ?',
          ),

          const SizedBox(height: 14),

          _buildQuickActions(),
        ],
      ),
    );
  }

  // ============================================================
  // SUGGESTIONS
  // ============================================================

  Widget _buildSuggestionRow({required String title1, required String title2}) {
    return Row(
      children: [
        Expanded(child: _buildSuggestionCard(title1)),

        const SizedBox(width: 10),

        Expanded(child: _buildSuggestionCard(title2)),
      ],
    );
  }

  Widget _buildSuggestionCard(String title) {
    return GestureDetector(
      onTap: () {
        _messageController.text = title;
      },

      child: Container(
        height: 70,

        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),

          borderRadius: BorderRadius.circular(14),

          border: Border.all(color: const Color(0xFFE8EBEF)),
        ),

        child: Align(
          alignment: Alignment.centerLeft,

          child: Text(
            title,

            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.gray500,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  Widget _buildQuickActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildQuickAction(
                icon: Icons.analytics_outlined,
                title: 'Analyser une\ncampagne',
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _buildQuickAction(
                icon: Icons.auto_graph,
                title: 'Créer un\nscénario',
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _buildQuickAction(
                icon: Icons.lightbulb_outline,
                title: 'Idées de\ncontenu',
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _buildQuickAction(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Optimiser le\nbudget',
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _buildQuickAction(
                icon: Icons.insights_outlined,
                title: 'Suivre mes KPI',
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _buildQuickAction(
                icon: Icons.psychology_outlined,
                title: 'Recommandations\nIA',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction({required IconData icon, required String title}) {
    return GestureDetector(
      onTap: () {
        _messageController.text = title.replaceAll('\n', ' ');
      },

      child: Container(
        height: 88,

        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),

          borderRadius: BorderRadius.circular(14),

          border: Border.all(color: const Color(0xFFE8EBEF)),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 21, color: AppColors.green),

            const SizedBox(height: 8),

            Text(
              title,

              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 9, color: AppColors.gray500),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CONVERSATION
  // ============================================================

  Widget _buildConversation() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),

      itemCount: _messages.length,

      itemBuilder: (context, index) {
        final message = _messages[index];

        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(_Message message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        constraints: const BoxConstraints(maxWidth: 270),

        margin: const EdgeInsets.only(bottom: 14),

        padding: const EdgeInsets.all(13),

        decoration: BoxDecoration(
          color: message.isUser ? AppColors.blue : const Color(0xFFF1F3F5),

          borderRadius: BorderRadius.circular(14),
        ),

        child: Text(
          message.text,

          style: TextStyle(
            fontSize: 12,
            height: 1.4,

            color: message.isUser ? Colors.white : AppColors.black,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INPUT
  // ============================================================

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),

      decoration: const BoxDecoration(
        color: Colors.white,

        border: Border(top: BorderSide(color: Color(0xFFF1F3F5))),
      ),

      child: Column(
        children: [
          _buildSuggestionChips(),

          const SizedBox(height: 8),

          Row(
            children: [
              Container(
                width: 40,
                height: 40,

                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F8),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.attach_file,
                  size: 19,
                  color: AppColors.gray500,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Container(
                  height: 46,

                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6F8),

                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: TextField(
                    controller: _messageController,

                    onSubmitted: (_) {
                      _sendMessage();
                    },

                    decoration: const InputDecoration(
                      hintText: 'Écrivez votre message...',

                      hintStyle: TextStyle(
                        fontSize: 11,
                        color: AppColors.gray400,
                      ),

                      border: InputBorder.none,

                      contentPadding: EdgeInsets.symmetric(horizontal: 14),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              GestureDetector(
                onTap: _sendMessage,

                child: Container(
                  width: 42,
                  height: 42,

                  decoration: const BoxDecoration(
                    color: AppColors.blue,
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.arrow_upward,
                    size: 19,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHIPS
  // ============================================================

  Widget _buildSuggestionChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: Row(
        children: [
          _buildChip('Analyser une campagne'),

          const SizedBox(width: 8),

          _buildChip('Créer un scénario'),

          const SizedBox(width: 8),

          _buildChip('Idées de contenu'),
        ],
      ),
    );
  }

  Widget _buildChip(String text) {
    return GestureDetector(
      onTap: () {
        _messageController.text = text;
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),

        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),

          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: const Color(0xFFE4E7EC)),
        ),

        child: Text(
          text,

          style: const TextStyle(fontSize: 9, color: AppColors.gray500),
        ),
      ),
    );
  }

  Widget buildKpiTable() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),

      child: Column(
        children: [
          _buildKpiHeader(),

          _buildKpiRow(
            indicator: 'Portée',
            objective: '50K',
            actual: '125K',
            difference: '+12%',
            positive: true,
          ),

          _buildKpiRow(
            indicator: 'Clics',
            objective: '5K',
            actual: '4,0K',
            difference: '-8%',
            positive: false,
          ),

          _buildKpiRow(
            indicator: 'Conversions',
            objective: '800',
            actual: '620',
            difference: '-24%',
            positive: false,
          ),

          _buildKpiRow(
            indicator: 'CPA',
            objective: '1 500',
            actual: '1 200',
            difference: '-20%',
            positive: true,
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),

            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),

            child: const Center(
              child: Text(
                'Voir le tableau de bord →',

                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),

        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),

      child: const Row(
        children: [
          Expanded(
            flex: 3,

            child: Text(
              'Indicateur',

              style: TextStyle(fontSize: 8, color: AppColors.gray500),
            ),
          ),

          Expanded(
            child: Text(
              'Objectif',

              style: TextStyle(fontSize: 8, color: AppColors.gray500),
            ),
          ),

          Expanded(
            child: Text(
              'Réel',

              style: TextStyle(fontSize: 8, color: AppColors.gray500),
            ),
          ),

          Expanded(
            child: Text(
              'Écart',

              style: TextStyle(fontSize: 8, color: AppColors.gray500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiRow({
    required String indicator,
    required String objective,
    required String actual,
    required String difference,
    required bool positive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F3F5))),
      ),

      child: Row(
        children: [
          Expanded(
            flex: 3,

            child: Text(
              indicator,

              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),

          Expanded(
            child: Text(
              objective,

              style: const TextStyle(fontSize: 9, color: AppColors.gray500),
            ),
          ),

          Expanded(
            child: Text(
              actual,

              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),

          Expanded(
            child: Text(
              difference,

              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,

                color: positive ? AppColors.green : const Color(0xFFE05252),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================================================
// MODEL MESSAGE
// ===============================================================

class _Message {
  final String text;

  final bool isUser;

  _Message({required this.text, required this.isUser});
}
