import 'package:flutter/material.dart';

import 'features/splash/presentation/splash_screen.dart';

//import 'features/home/home.dart';

void main() {
  runApp(const KiyanzaApp());
}

class KiyanzaApp extends StatelessWidget {
  const KiyanzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      title: 'Kiyanza',
      home: const SplashScreen(),
    );
  }
}
//home: const HomeScreen(),
