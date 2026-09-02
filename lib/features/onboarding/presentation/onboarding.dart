import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Votre copilote marketing',
      'description': 'Il transforme la donnée en opportunités de croissance.',
    },
    {
      'title': 'Comprenez votre marché',
      'description': 'Il analyse les tendances, votre audience et vos performances en temps réel pour prendre des décisions éclairées.',
    },
    {
      'title': 'Simulez. Optimisez',
      'description': 'Il analyse et teste différents scénarios pour optimiser vos budgets et investissez là où l’impact sera le plus fort.',
    },
    {
      'title': 'Passez à l’action partout',
      'description': 'Gérez vos missions sur le terrain, suivez et remontez des données clés où que vous soyez.',
    },
  ];

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF173F27),

      body: SafeArea(
        child: Column(
          children: [
            // Bouton Passer
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextButton(
                  onPressed: () {
                    _pageController.animateToPage(
                      3,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text(
                    'Passer',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,

                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },

                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        // Illustration temporaire
                        Container(
                          width: 230,
                          height: 230,

                          decoration: BoxDecoration(
                            color: const Color(0xFF267A47),
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.insights,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Titre
                        Text(
                          onboardingData[index]['title']!,
                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Description
                        Text(
                          onboardingData[index]['description']!,
                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicateurs + navigation
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  // Retour
                  TextButton(
                    onPressed: _currentPage == 0 ? null : _previousPage,

                    child: Text(
                      'Retour',

                      style: TextStyle(
                        color: _currentPage == 0
                            ? Colors.transparent
                            : Colors.white70,
                      ),
                    ),
                  ),

                  // Indicateurs
                  Row(
                    children: List.generate(
                      onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),

                        margin: const EdgeInsets.symmetric(horizontal: 3),

                        width: _currentPage == index ? 28 : 6,

                        height: 6,

                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFF1BB14A)
                              : Colors.white,

                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  // Bouton suivant
                  _currentPage == onboardingData.length - 1
                      ? ElevatedButton(
                          onPressed: () {
                            // Aller vers Login plus tard
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1BB14A),

                            foregroundColor: Colors.white,

                            shape: const StadiumBorder(),

                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                          ),

                          child: const Text('Se connecter'),
                        )
                      : CircleAvatar(
                          radius: 25,

                          backgroundColor: const Color(0xFF1BB14A),

                          child: IconButton(
                            onPressed: _nextPage,

                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 18,
                            ),
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
}
