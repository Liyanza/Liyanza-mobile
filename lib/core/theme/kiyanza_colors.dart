import 'package:flutter/material.dart';

class AppColors {
  // ==================================================
  // PRIMARY
  // ==================================================

  static const Color blue = Color(0xFF296BD6);
  static const Color green = Color(0xFF1BB14A);
  static const Color orange = Color(0xFFFF6A00);

  // ==================================================
  // GRAY
  // ==================================================

  static const Color gray100 = Color(0xFFF6F6F6);
  static const Color gray200 = Color(0xFFE4E4E4);
  static const Color gray300 = Color(0xFFCDCDCD);
  static const Color gray400 = Color(0xFFBABABA);
  static const Color gray500 = Color(0xFF8C8C8C);
  static const Color gray600 = Color(0xFF767676);
  static const Color gray700 = Color(0xFF57595B);

  // ==================================================
  // SUCCESS
  // ==================================================

  static const Color success100 = Color(0xFFCFF2D8);
  static const Color success200 = Color(0xFF9DE5B0);
  static const Color success300 = Color(0xFF6ED989);
  static const Color success400 = Color(0xFF35C75A);
  static const Color success500 = Color(0xFF2AA147);
  static const Color success600 = Color(0xFF32862B);
  static const Color success700 = Color(0xFF19612B);

  // ==================================================
  // WARNING
  // ==================================================

  static const Color warning100 = Color(0xFFFFE1C8);
  static const Color warning200 = Color(0xFFFFBF8C);
  static const Color warning300 = Color(0xFFFF9E4F);
  static const Color warning400 = Color(0xFFFF821D);
  static const Color warning500 = Color(0xFFFC5100);
  static const Color warning600 = Color(0xFFD94601);
  static const Color warning700 = Color(0xFFA33501);

  // ==================================================
  // ERROR
  // ==================================================

  static const Color error100 = Color(0xFFFDB8D0);
  static const Color error200 = Color(0xFFF6B1A2);
  static const Color error300 = Color(0xFFF28A73);
  static const Color error400 = Color(0xFFEE6344);
  static const Color error500 = Color(0xFFE93C16);
  static const Color error600 = Color(0xFFCC3423);
  static const Color error700 = Color(0xFFBC3213);

  // ==================================================
  // BASIQUES
  // ==================================================

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ==================================================
  // GRADIENT LIYANZA
  // ==================================================

  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [green, Color(0xFF137E35), Color(0xFF0B4B1F)],
    stops: [0.35, 0.68, 1.0],
  );
}
