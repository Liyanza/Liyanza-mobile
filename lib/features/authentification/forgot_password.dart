import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _emailSent = false;
  bool _resetPassword = false;

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Vérifie simplement si l'email semble valide
  bool get _isEmailValid {
    return _emailController.text.contains('@') &&
        _emailController.text.contains('.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),

          child: Column(
            children: [
              // ========================================
              // BOUTON RETOUR
              // ========================================

              Align(
                alignment: Alignment.centerLeft,

                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },

                  child: Container(
                    width: 40,
                    height: 40,

                    decoration: const BoxDecoration(
                      color: Color(0xFFDFF5E7),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Color(0xFF137E35),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ========================================
              // CONTENU
              // ========================================
              if (!_emailSent && !_resetPassword)
                _buildForgotPassword()
              else if (_emailSent && !_resetPassword)
                _buildEmailSent()
              else
                _buildNewPassword(),
            ],
          ),
        ),
      ),
    );
  }

  // ====================================================
  // ÉTAPE 1 : MOT DE PASSE OUBLIÉ
  // ====================================================

  Widget _buildForgotPassword() {
    return Column(
      children: [
        // Image cadenas
        Image.asset(
          'assets/images/forgot_password.png',
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 20),

        const Text(
          'Mot de passe oublier ?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        const Text(
          'Entrez votre email. Nous vous enverrons\n'
          'un lien pour réinitialiser votre mot de passe.',
          textAlign: TextAlign.center,

          style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
        ),

        const SizedBox(height: 30),

        // EMAIL
        const Align(
          alignment: Alignment.centerLeft,

          child: Text(
            'Adresse email',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: _emailController,

          keyboardType: TextInputType.emailAddress,

          onChanged: (value) {
            setState(() {});
          },

          decoration: InputDecoration(
            hintText: 'Entrez votre adresse email',

            hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),

              borderSide: const BorderSide(
                color: Color(0xFF1BB14A),
                width: 1.5,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // BOUTON
        SizedBox(
          width: double.infinity,
          height: 48,

          child: ElevatedButton(
            onPressed: _isEmailValid
                ? () {
                    setState(() {
                      _emailSent = true;
                    });
                  }
                : null,

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1BB14A),

              disabledBackgroundColor: const Color(0xFF8BD9A8),

              foregroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),

              elevation: 0,
            ),

            child: const Text(
              'Envoyer le lien',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(height: 110),

        _buildBackToLogin(),
      ],
    );
  }

  // ====================================================
  // ÉTAPE 2 : EMAIL ENVOYÉ
  // ====================================================

  Widget _buildEmailSent() {
    return Column(
      children: [
        // Illustration
        Image.asset(
          'assets/images/email_sent.png',
          width: 130,
          height: 130,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 20),

        const Text(
          'Un email a été envoyé',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 5),

        Text(
          _emailController.text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),

        const SizedBox(height: 15),

        const Text(
          'Nous venons de vous envoyer un lien\n'
          'de réinitialisation. Vérifiez votre boîte\n'
          'de réception et suivez les instructions.',
          textAlign: TextAlign.center,

          style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
        ),

        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          height: 48,

          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _resetPassword = true;
              });
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1BB14A),

              foregroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),

              elevation: 0,
            ),

            child: const Text(
              'Ouvrir Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(height: 110),

        const Text(
          'Vous ne voyez pas l’e-mail ?',
          style: TextStyle(fontSize: 11),
        ),

        GestureDetector(
          onTap: () {
            setState(() {
              _emailSent = false;
            });
          },

          child: const Text(
            'Renvoyer l’email',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF1BB14A),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 20),

        _buildBackToLogin(),
      ],
    );
  }

  // ====================================================
  // ÉTAPE 3 : NOUVEAU MOT DE PASSE
  // ====================================================

  Widget _buildNewPassword() {
    return Column(
      children: [
        // Icône cadenas
        Container(
          width: 90,
          height: 90,

          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF1BB14A), width: 2),

            shape: BoxShape.circle,
          ),

          child: const Icon(
            Icons.lock_outline,
            size: 45,
            color: Color(0xFF1BB14A),
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          'Nouveau mot de passe',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        const Text(
          'Choisissez un nouveau mot de passe sécurisé.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),

        const SizedBox(height: 30),

        // NOUVEAU MOT DE PASSE
        const Align(
          alignment: Alignment.centerLeft,

          child: Text(
            'Nouveau mot de passe',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: _newPasswordController,

          obscureText: _obscureNewPassword,

          decoration: InputDecoration(
            hintText: 'Entrez votre nouveau mot de passe',

            suffixIcon: IconButton(
              icon: Icon(
                _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
              ),

              onPressed: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
            ),

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),

        const SizedBox(height: 15),

        // CONFIRMATION
        const Align(
          alignment: Alignment.centerLeft,

          child: Text(
            'Confirmez votre mot de passe',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: _confirmPasswordController,

          obscureText: _obscureConfirmPassword,

          decoration: InputDecoration(
            hintText: 'Entrez votre nouveau mot de passe',

            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),

              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),

        const SizedBox(height: 25),

        // BOUTON
        SizedBox(
          width: double.infinity,
          height: 48,

          child: ElevatedButton(
            onPressed: () {
              // Réinitialisation réelle avec le backend plus tard
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1BB14A),

              foregroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),

              elevation: 0,
            ),

            child: const Text(
              'Réinitialiser',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(height: 110),

        _buildBackToLogin(),
      ],
    );
  }

  // ====================================================
  // RETOUR LOGIN
  // ====================================================

  Widget _buildBackToLogin() {
    return Column(
      children: [
        const Text(
          'Vous vous souvenez de votre mot de passe ?',
          style: TextStyle(fontSize: 11),
        ),

        const SizedBox(height: 5),

        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },

          child: const Text(
            'Se connecter',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF1BB14A),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
