import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/triage_landing/presentation/pages/landing_page.dart';

void main() {
  runApp(const AbogadosLamaApp());
}

class AbogadosLamaApp extends StatelessWidget {
  const AbogadosLamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abogados Lama',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LandingPage(),
    );
  }
}
