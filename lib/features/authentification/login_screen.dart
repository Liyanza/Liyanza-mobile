import 'package:flutter/material.dart';

import 'forgot_password.dart';
import '../../core/theme/kiyanza_colors.dart';
import '../../../services_API/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  bool _rememberMe = false;
  bool _obscurePassword = true;
  

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final success = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        // Rediriger vers l'accueil ou le menu principal
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Identifiants invalides ou serveur indisponible')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // =========================
    // RÉFÉRENCE = cadre Figma "Login 1" (402 x 874)
    // Facteurs d'échelle pour coller à la maquette sur
    // n'importe quel écran, SANS jamais scroller.
    // =========================
    final size = MediaQuery.of(context).size;
    const double refW = 402;
    const double refH = 874;
    final double scaleW = size.width / refW;
    final double scaleH = size.height / refH;
    final double scale = scaleW < scaleH ? scaleW : scaleH;

    double w(double px) => px * scaleW;
    double h(double px) => px * scaleH;
    double s(double px) => px * scale;

    return Scaffold(
      backgroundColor: const Color(0xFF0B4B1F),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // =========================
          // FOND — dégradé vert (token du projet)
          // =========================
          Container(
            decoration: const BoxDecoration(gradient: AppColors.greenGradient),
          ),

          // =========================
          // FORME DÉCO EN BAS (Ellipse58 sur la maquette)
          // Position/tailles fidèles au node Figma, mises à l'échelle.
          // =========================
          Positioned(
            left: w(-9.57),
            top: h(423.17),
            width: w(301.68),
            height: h(465.83),
            child: Image.asset(
              'assets/images/fond_blanc.png',
              fit: BoxFit.contain,
            ),
          ),

          // =========================
          // CONTENU — sans scroll
          // =========================
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w(16), vertical: h(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: h(30)),

                  // LOGO (colibri blanc)
                  Image.asset('assets/images/logo_blanc.png', width: w(90)),

                  SizedBox(height: h(35)),

                  // TITRE
                  Text(
                    'Content de vous revoir !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: s(24),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: h(4)),
                  Text(
                    'Connectez-vous pour continuer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: s(16),
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),

                  SizedBox(height: h(100)),

                  // =========================
                  // CARTE FORMULAIRE — occupe le reste, jamais de scroll
                  // =========================
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                              minHeight: constraints.maxHeight,
                            ),
                            child: Container(
                              width: constraints.maxWidth,
                              padding: EdgeInsets.all(s(24)),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(s(15)),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // GOOGLE — bouton pilule
                                      _SocialButton(
                                        height: h(46),
                                        radius: s(100),
                                        icon: Image.asset(
                                          'assets/icons/google.png',
                                          width: s(18),
                                          height: s(18),
                                          // Si l'asset n'existe pas encore dans le projet,
                                          // on affiche un repli au lieu de planter.
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) => _GoogleGIcon(size: s(18)),
                                        ),
                                        label: 'Continuer avec  Google',
                                        fontSize: s(16),
                                        onTap: () {},
                                      ),

                                      SizedBox(height: h(24)),

                                      // FACEBOOK — bouton pilule
                                      _SocialButton(
                                        height: h(46),
                                        radius: s(100),
                                        icon: Icon(
                                          Icons.facebook,
                                          color: const Color(0xFF1877F2),
                                          size: s(24),
                                        ),
                                        label: 'Continuer avec Facebook',
                                        fontSize: s(16),
                                        onTap: () {},
                                      ),

                                      SizedBox(height: h(24)),

                                      // SÉPARATEUR "Ou se connecter avec"
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: const Color(0xFFE5E7EB),
                                              height: 1,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: w(16),
                                            ),
                                            child: Text(
                                              'Ou se connecter avec',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: s(12),
                                                color: const Color(0xFF6C7278),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Divider(
                                              color: const Color(0xFFE5E7EB),
                                              height: 1,
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: h(24)),

                                      // CHAMP EMAIL — le texte "Email" sert de hint, pas de label séparé
                                      _AuthField(
                                        controller: _emailController,
                                        hint: 'Email',
                                        height: h(46),
                                        radius: s(10),
                                        fontSize: s(16),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),

                                      SizedBox(height: h(16)),

                                      // CHAMP MOT DE PASSE
                                      _AuthField(
                                        controller: _passwordController,
                                        hint: 'Mot de passe',
                                        height: h(46),
                                        radius: s(10),
                                        fontSize: s(16),
                                        obscureText: _obscurePassword,
                                        suffix: IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            size: s(16),
                                            color: const Color(0xFF6C7278),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                        ),
                                      ),

                                      SizedBox(height: h(16)),

                                      // SE SOUVENIR / MOT DE PASSE OUBLIÉ
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _rememberMe = !_rememberMe;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                _RememberMeCheck(
                                                  value: _rememberMe,
                                                  size: s(19),
                                                ),
                                                SizedBox(width: w(5)),
                                                Text(
                                                  'Se souvenir de moi',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: s(12),
                                                    color: const Color(
                                                      0xFF6C7278,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ForgotPasswordScreen(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Mot de passe oublier ?',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w600,
                                                fontSize: s(12),
                                                color: AppColors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: h(24)),

                                      // BOUTON CONNEXION — pilule, dégradé vert
                                      SizedBox(
                                        width: double.infinity,
                                        height: h(48),
                                        child: ElevatedButton(
                                          onPressed:
                                              _isLoading ? null : _handleLogin,
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            backgroundColor: AppColors.green,
                                            shadowColor: Colors.transparent,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(s(100)),
                                            ),
                                          ),
                                          child: _isLoading
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          Colors.white,
                                                        ),
                                                      ),
                                                )
                                              : Text(
                                                  'Se connecter',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    fontSize: s(16),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // INSCRIPTION (collé en bas de la carte via spaceBetween)
                                  Padding(
                                    padding: EdgeInsets.only(top: h(16)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Pas encore de compte ? ',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            fontSize: s(12),
                                            color: const Color(0xFF6C7278),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            'Créer un compte',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              fontSize: s(12),
                                              color: AppColors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================
// Bouton social pilule (Google / Facebook)
// =========================
class _SocialButton extends StatelessWidget {
  final double height;
  final double radius;
  final Widget icon;
  final String label;
  final double fontSize;
  final VoidCallback onTap;

  const _SocialButton({
    required this.height,
    required this.radius,
    required this.icon,
    required this.label,
    required this.fontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFEFF0F6)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================
// Repli pour le logo Google si assets/icons/google.png est absent.
// Remplacé automatiquement par la vraie image dès qu'elle existe.
// =========================
class _GoogleGIcon extends StatelessWidget {
  final double size;

  const _GoogleGIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            fontSize: size * 0.85,
            fontWeight: FontWeight.bold,
            height: 1,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [
                  Color(0xFF4285F4),
                  Color(0xFF34A853),
                  Color(0xFFFBBC05),
                  Color(0xFFEA4335),
                ],
              ).createShader(Rect.fromLTWH(0, 0, size, size)),
          ),
        ),
      ),
    );
  }
}

// =========================
// Champ de saisie style maquette (le hint fait office de label)
// =========================
class _AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final double height;
  final double radius;
  final double fontSize;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;

  const _AuthField({
    required this.controller,
    required this.hint,
    required this.height,
    required this.radius,
    required this.fontSize,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFEDF1F3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3DE4E5E7),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: fontSize,
          color: const Color(0xFF1A1C1E),
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: fontSize,
            color: const Color(0xFF1A1C1E),
          ),
          suffixIcon: suffix,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
        ),
      ),
    );
  }
}

// =========================
// Case "Se souvenir de moi" custom (remplace le Checkbox par défaut)
// =========================
class _RememberMeCheck extends StatelessWidget {
  final bool value;
  final double size;

  const _RememberMeCheck({required this.value, required this.size});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: value ? AppColors.green : Colors.white,
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(
          color: value ? AppColors.green : const Color(0xFFACB5BB),
          width: 1.2,
        ),
      ),
      child: value
          ? Icon(Icons.check, size: size * 0.7, color: Colors.white)
          : null,
    );
  }
}
