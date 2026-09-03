import 'package:flutter/material.dart';

import 'login_success.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E7A43),

      body: Stack(
        children: [
          // =========================
          // FOND VERT
          // =========================
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.35, 0.68, 1.0],
                colors: [
                  Color(0xFF1BB14A),
                  Color(0xFF137E35),
                  Color(0xFF0B4B1F),
                ],
              ),
            ),
          ),

          // =========================
          // IMAGE FOND BLANC
          // =========================
          Positioned(
            bottom: -20,
            left: -20,
            right: 120,
            child: Image.asset(
              'assets/images/fond_blanc.png',
              width: 500,
              fit: BoxFit.fitWidth,
            ),
          ),

          // =========================
          // CONTENU
          // =========================
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 100,
                ),

                child: Column(
                  children: [
                    // =========================
                    // LOGO
                    // =========================
                    Image.asset('assets/images/logo_blanc.png', width: 110),

                    const SizedBox(height: 30),

                    // =========================
                    // TITRE
                    // =========================
                    const Column(
                      children: [
                        Text(
                          'Content de vous revoir !',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          'Connectez-vous pour continuer',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // =========================
                    // FORMULAIRE
                    // =========================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // GOOGLE
                          SizedBox(
                            width: double.infinity,
                            height: 45,

                            child: OutlinedButton(
                              onPressed: () {},

                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFE0E0E0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),

                              child: const Text(
                                'Continuer avec Google',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // FACEBOOK
                          SizedBox(
                            width: double.infinity,
                            height: 45,

                            child: OutlinedButton(
                              onPressed: () {},

                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFE0E0E0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),

                              child: const Text(
                                'Continuer avec Facebook',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // EMAIL
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 6),

                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,

                            decoration: InputDecoration(
                              hintText: 'Entrez votre email',

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF1BB14A),
                                  width: 1.5,
                                ),
                              ),

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // MOT DE PASSE
                          const Text(
                            'Mot de passe',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 6),

                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,

                            decoration: InputDecoration(
                              hintText: 'Entrez votre mot de passe',

                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 20,
                                ),

                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF1BB14A),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // SE SOUVENIR / OUBLIÉ
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    activeColor: const Color(0xFF1BB14A),

                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                  ),

                                  const Text(
                                    'Se souvenir de moi',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen(),
                                    ),
                                  );
                                },

                                child: const Text(
                                  'Mot de passe oublié ?',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF1BB14A),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // BOUTON CONNEXION
                          SizedBox(
                            width: double.infinity,
                            height: 48,

                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginSuccessScreen(),
                                  ),
                                );
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1BB14A),
                                foregroundColor: Colors.white,
                                elevation: 0,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),

                              child: const Text(
                                'Se connecter',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // INSCRIPTION
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                const Text(
                                  'Pas encore de compte ? ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {},

                                  child: const Text(
                                    'Créer un compte',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1BB14A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
