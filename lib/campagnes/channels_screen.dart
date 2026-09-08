import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';
import 'campaign_step_dots.dart';
import '../simulation/simulation.dart';

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  final List<_ChannelOption> _channels = [
    _ChannelOption(
      name: 'Facebook',
      description: 'Atteignez votre audience sur Facebook',
      icon: Icons.facebook,
      iconColor: AppColors.blue,
      selected: true,
    ),
    _ChannelOption(
      name: 'Instagram',
      description: 'Touchez votre communauté',
      icon: Icons.camera_alt_outlined,
      iconColor: const Color(0xFFE1306C),
      selected: false,
    ),
    _ChannelOption(
      name: 'WhatsApp',
      description: 'Communiquez directement',
      icon: Icons.chat_outlined,
      iconColor: AppColors.green,
      selected: false,
    ),
    _ChannelOption(
      name: 'TikTok',
      description: 'Captez une audience engagée',
      icon: Icons.music_note,
      iconColor: AppColors.black,
      selected: false,
    ),
    _ChannelOption(
      name: 'YouTube',
      description: 'Vidéo et visibilité maximale',
      icon: Icons.play_circle_outline,
      iconColor: const Color(0xFFFF0000),
      selected: false,
    ),
  ];

  void _toggleChannel(int index) {
    setState(() {
      _channels[index].selected = !_channels[index].selected;
    });
  }

  bool get _hasSelection => _channels.any((channel) => channel.selected);

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
            // STEP DOTS
            // =================================================
            const CampaignStepDots(currentStep: 4),

            // =================================================
            // CONTENU
            // =================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Sélectionnez les canaux à utiliser',

                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildChannelsList(),
                  ],
                ),
              ),
            ),

            // =================================================
            // BOUTON CONTINUER
            // =================================================
            _buildContinueButton(context),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // HEADER
  // ===========================================================

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

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
                'Canaux de diffusion',

                style: TextStyle(
                  fontSize: AppSizes.text16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          const SizedBox(width: 22),
        ],
      ),
    );
  }

  // ===========================================================
  // LISTE DES CANAUX
  // ===========================================================

  Widget _buildChannelsList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),

      child: Column(
        children: List.generate(_channels.length, (index) {
          final channel = _channels[index];
          final bool isLast = index == _channels.length - 1;

          return GestureDetector(
            onTap: () => _toggleChannel(index),

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(
                          color: Color(0xFFF3F4F6),
                          width: 1.2,
                        ),
                      ),
              ),

              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,

                    decoration: BoxDecoration(
                      color: channel.selected
                          ? AppColors.blue
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: channel.selected
                            ? AppColors.blue
                            : const Color(0xFFD1D5DB),
                        width: 1.2,
                      ),
                    ),

                    child: channel.selected
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: AppColors.white,
                          )
                        : null,
                  ),

                  const SizedBox(width: 12),

                  Container(
                    width: 40,
                    height: 40,

                    decoration: BoxDecoration(
                      color: channel.iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Icon(
                      channel.icon,
                      size: 18,
                      color: channel.iconColor,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          channel.name,

                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          channel.description,

                          style: const TextStyle(
                            fontSize: 11.5,
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
        }),
      ),
    );
  }

  // ===========================================================
  // BOUTON CONTINUER
  // ===========================================================

  Widget _buildContinueButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

      child: SizedBox(
        width: double.infinity,
        height: 54,

        child: ElevatedButton(
          onPressed: _hasSelection
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimulationScreen(),
                    ),
                  );
                }
              : null,

          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            disabledBackgroundColor: AppColors.gray100,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),

            elevation: 0,
          ),

          child: const Text(
            'Continuer',

            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
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

class _ChannelOption {
  final String name;
  final String description;
  final IconData icon;
  final Color iconColor;
  bool selected;

  _ChannelOption({
    required this.name,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.selected,
  });
}
