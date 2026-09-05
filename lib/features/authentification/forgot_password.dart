import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // ==========================================================
  // ETATS
  // ==========================================================

  bool _emailSent = false;

  bool _resetPassword = false;

  bool _passwordResetSuccess = false;

  bool _obscureNewPassword = true;

  bool _obscureConfirmPassword = true;

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // ==========================================================
  // VALIDATION EMAIL
  // ==========================================================

  bool get _isEmailValid {
    final email = _emailController.text.trim();

    return email.contains('@') && email.contains('.');
  }

  // ==========================================================
  // VALIDATION MOT DE PASSE
  // ==========================================================

  bool get _isPasswordValid {
    return _newPasswordController.text.length >= 4 &&
        _newPasswordController.text == _confirmPasswordController.text;
  }

  // ==========================================================
  // BUILD PRINCIPAL
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPadding,
            vertical: AppSizes.verticalPadding,
          ),

          child: Column(
            children: [
              // ==================================================
              // BOUTON RETOUR
              // ==================================================

              if (!_passwordResetSuccess)
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
                        color: AppColors.success100,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 17,
                        color: AppColors.success700,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: AppSizes.space20),

              // ==================================================
              // AFFICHAGE DES DIFFERENTES ETAPES
              // ==================================================
              if (!_emailSent && !_resetPassword && !_passwordResetSuccess)
                _buildForgotPassword()
              else if (_emailSent && !_resetPassword && !_passwordResetSuccess)
                _buildEmailSent()
              else if (_resetPassword && !_passwordResetSuccess)
                _buildNewPassword()
              else
                _buildSuccess(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // ETAPE 1
  // MOT DE PASSE OUBLIE
  // ==========================================================

  Widget _buildForgotPassword() {
    return Column(
      children: [
        // ------------------------------------------------------
        // IMAGE CADENAS
        // ------------------------------------------------------

        Image.asset(
          'assets/images/forgot_password.png',
          width: AppSizes.logoMedium,
          height: AppSizes.logoMedium,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: AppSizes.space16),

        // ------------------------------------------------------
        // TITRE
        // ------------------------------------------------------
        const Text(
          'Mot de passe oublié ?',
          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: AppSizes.text20,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: AppSizes.space8),

        // ------------------------------------------------------
        // DESCRIPTION
        // ------------------------------------------------------
        const Text(
          'Entrez votre email. Nous vous enverrons\n'
          'un lien pour réinitialiser votre mot de passe.',

          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: AppSizes.text12,
            color: AppColors.gray500,
            height: 1.5,
          ),
        ),

        const SizedBox(height: AppSizes.space28),

        // ------------------------------------------------------
        // LABEL
        // ------------------------------------------------------
        const Align(
          alignment: Alignment.centerLeft,

          child: Text(
            'Adresse email',

            style: TextStyle(
              fontSize: AppSizes.text12,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),

        const SizedBox(height: AppSizes.space8),

        // ------------------------------------------------------
        // CHAMP EMAIL
        // ------------------------------------------------------
        TextField(
          controller: _emailController,

          keyboardType: TextInputType.emailAddress,

          onChanged: (_) {
            setState(() {});
          },

          decoration: InputDecoration(
            hintText: 'Entrez votre adresse email',

            hintStyle: const TextStyle(
              fontSize: AppSizes.text12,
              color: AppColors.gray400,
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.space12,
              vertical: AppSizes.space12,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.inputRadius),

              borderSide: const BorderSide(color: AppColors.gray200),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.inputRadius),

              borderSide: const BorderSide(color: AppColors.gray200),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.inputRadius),

              borderSide: const BorderSide(color: AppColors.green, width: 1.5),
            ),
          ),
        ),

        const SizedBox(height: AppSizes.space20),

        // ------------------------------------------------------
        // BOUTON ENVOYER
        // ------------------------------------------------------
        _primaryButton(
          text: 'Envoyer le lien',

          enabled: _isEmailValid,

          onPressed: () {
            setState(() {
              _emailSent = true;
            });
          },
        ),

        const SizedBox(height: 110),

        // ------------------------------------------------------
        // RETOUR LOGIN
        // ------------------------------------------------------
        _buildBackToLogin(),
      ],
    );
  }

  // ==========================================================
  // ETAPE 2
  // EMAIL ENVOYE
  // ==========================================================

  Widget _buildEmailSent() {
    return Column(
      children: [
        // ------------------------------------------------------
        // IMAGE EMAIL
        // ------------------------------------------------------

        Image.asset(
          'assets/images/email_sent.png',
          width: AppSizes.logoMedium,
          height: AppSizes.logoMedium,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: AppSizes.space16),

        // ------------------------------------------------------
        // TITRE
        // ------------------------------------------------------
        const Text(
          'Un email a été envoyé',

          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: AppSizes.text20,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: AppSizes.space4),

        // ------------------------------------------------------
        // EMAIL
        // ------------------------------------------------------
        Text(
          _emailController.text,

          style: const TextStyle(
            fontSize: AppSizes.text12,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: AppSizes.space16),

        // ------------------------------------------------------
        // DESCRIPTION
        // ------------------------------------------------------
        const Text(
          'Nous venons de vous envoyer un lien\n'
          'de réinitialisation. Vérifiez votre boîte\n'
          'de réception et suivez les instructions.',

          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: AppSizes.text12,
            color: AppColors.gray500,
            height: 1.5,
          ),
        ),

        const SizedBox(height: AppSizes.space28),

        // ------------------------------------------------------
        // OUVRIR EMAIL
        // ------------------------------------------------------
        _primaryButton(
          text: 'Ouvrir Email',

          onPressed: () {
            setState(() {
              _resetPassword = true;
            });
          },
        ),

        const SizedBox(height: 100),

        // ------------------------------------------------------
        // RENVOYER EMAIL
        // ------------------------------------------------------
        const Text(
          'Vous ne voyez pas l’e-mail ?',

          style: TextStyle(fontSize: AppSizes.text10, color: AppColors.black),
        ),

        const SizedBox(height: AppSizes.space4),

        GestureDetector(
          onTap: () {
            // Plus tard :
            // appel API pour renvoyer l'email
          },

          child: const Text(
            'Renvoyer l’email',

            style: TextStyle(
              fontSize: AppSizes.text10,
              color: AppColors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: AppSizes.space20),

        _buildBackToLogin(),
      ],
    );
  }

  // ==========================================================
  // ETAPE 3
  // NOUVEAU MOT DE PASSE
  // ==========================================================

  Widget _buildNewPassword() {
    return Column(
      children: [
        // ------------------------------------------------------
        // ICONE CADENAS
        // ------------------------------------------------------

        Container(
          width: 70,
          height: 70,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            border: Border.all(color: AppColors.green, width: 1.5),
          ),

          child: const Icon(
            Icons.lock_outline,
            color: AppColors.green,
            size: 32,
          ),
        ),

        const SizedBox(height: AppSizes.space20),

        // ------------------------------------------------------
        // TITRE
        // ------------------------------------------------------
        const Text(
          'Nouveau mot de passe',

          style: TextStyle(
            fontSize: AppSizes.text20,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: AppSizes.space8),

        // ------------------------------------------------------
        // DESCRIPTION
        // ------------------------------------------------------
        const Text(
          'Choisissez un nouveau mot de passe sécurisé.',

          textAlign: TextAlign.center,

          style: TextStyle(fontSize: AppSizes.text12, color: AppColors.gray500),
        ),

        const SizedBox(height: AppSizes.space28),

        // ------------------------------------------------------
        // NOUVEAU MOT DE PASSE
        // ------------------------------------------------------
        const Align(
          alignment: Alignment.centerLeft,

          child: Text(
            'Nouveau mot de passe',

            style: TextStyle(
              fontSize: AppSizes.text12,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),

        const SizedBox(height: AppSizes.space8),

        TextField(
          controller: _newPasswordController,

          obscureText: _obscureNewPassword,

          onChanged: (_) {
            setState(() {});
          },

          decoration: InputDecoration(
            hintText: 'Entrez votre nouveau mot de passe',

            hintStyle: const TextStyle(
              fontSize: AppSizes.text12,
              color: AppColors.gray400,
            ),

            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },

              icon: Icon(
                _obscureNewPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,

                size: AppSizes.iconMedium,

                color: AppColors.gray600,
              ),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.space12,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.inputRadius),

              borderSide: const BorderSide(color: AppColors.gray200),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.inputRadius),

              borderSide: const BorderSide(color: AppColors.green, width: 1.5),
            ),
          ),
        ),

        const SizedBox(height: AppSizes.space16),

        // ------------------------------------------------------
        // CONFIRMATION
        // ------------------------------------------------------
        const Align(
          alignment: Alignment.centerLeft,

          child: Text(
            'Confirmez votre mot de passe',

            style: TextStyle(
              fontSize: AppSizes.text12,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),

        const SizedBox(height: AppSizes.space8),

        TextField(
          controller: _confirmPasswordController,

          obscureText: _obscureConfirmPassword,

          onChanged: (_) {
            setState(() {});
          },

          decoration: InputDecoration(
            hintText: 'Entrez votre nouveau mot de passe',

            hintStyle: const TextStyle(
              fontSize: AppSizes.text12,
              color: AppColors.gray400,
            ),

            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },

              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,

                size: AppSizes.iconMedium,

                color: AppColors.gray600,
              ),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.space12,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.inputRadius),

              borderSide: const BorderSide(color: AppColors.gray200),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.inputRadius),

              borderSide: const BorderSide(color: AppColors.green, width: 1.5),
            ),
          ),
        ),

        const SizedBox(height: AppSizes.space24),

        // ------------------------------------------------------
        // BOUTON REINITIALISER
        // ------------------------------------------------------
        _primaryButton(
          text: 'Réinitialiser',

          enabled: _isPasswordValid,

          onPressed: () {
            setState(() {
              _passwordResetSuccess = true;
            });
          },
        ),
      ],
    );
  }

  // ==========================================================
  // ETAPE 4
  // SUCCES
  // ==========================================================

  Widget _buildSuccess() {
    return Column(
      children: [
        const SizedBox(height: 50),

        // ------------------------------------------------------
        // CERCLE DE SUCCES
        // ------------------------------------------------------
        Container(
          width: 90,
          height: 90,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: AppColors.success100,

            border: Border.all(color: AppColors.success200, width: 8),
          ),

          child: Container(
            margin: const EdgeInsets.all(8),

            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.green,
            ),

            child: const Icon(Icons.check, color: AppColors.white, size: 35),
          ),
        ),

        const SizedBox(height: AppSizes.space28),

        // ------------------------------------------------------
        // TITRE
        // ------------------------------------------------------
        const Text(
          'Mot de passe réinitialisé !',

          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: AppSizes.text20,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: AppSizes.space8),

        // ------------------------------------------------------
        // DESCRIPTION
        // ------------------------------------------------------
        const Text(
          'Votre mot de passe a été modifié avec succès.\n'
          'Vous pouvez maintenant vous connecter avec\n'
          'votre nouveau mot de passe.',

          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: AppSizes.text12,
            color: AppColors.gray500,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 40),

        // ------------------------------------------------------
        // BOUTON SE CONNECTER
        // ------------------------------------------------------
        _primaryButton(
          text: 'Se connecter',

          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  // ==========================================================
  // BOUTON PRINCIPAL
  // ==========================================================

  Widget _primaryButton({
    required String text,
    required VoidCallback onPressed,
    bool enabled = true,
  }) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,

      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,

          disabledBackgroundColor: AppColors.success200,

          foregroundColor: AppColors.white,

          disabledForegroundColor: AppColors.white,

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
        ),

        child: Text(
          text,

          style: const TextStyle(
            fontSize: AppSizes.text12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // RETOUR LOGIN
  // ==========================================================

  Widget _buildBackToLogin() {
    return Column(
      children: [
        const Text(
          'Vous vous souvenez de votre mot de passe ?',

          style: TextStyle(fontSize: AppSizes.text10, color: AppColors.black),
        ),

        const SizedBox(height: AppSizes.space4),

        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },

          child: const Text(
            'Se connecter',

            style: TextStyle(
              fontSize: AppSizes.text10,
              color: AppColors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
