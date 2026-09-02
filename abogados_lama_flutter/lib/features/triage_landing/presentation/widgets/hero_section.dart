import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_breakpoints.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onCtaPressed;

  const HeroSection({super.key, required this.onCtaPressed});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = AppBreakpoints.isMobile(width);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24.0 : 64.0,
        vertical: 48.0,
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildContent(context, isMobile),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildContent(context, isMobile),
                  ),
                ),
                const SizedBox(width: 48),
                Expanded(
                  flex: 5,
                  child: _buildPortraitWidget(),
                ),
              ],
            ),
    );
  }

  List<Widget> _buildContent(BuildContext context, bool isMobile) {
    return [
      Row(
        children: [
          Container(
            width: 32,
            height: 1,
            color: AppTheme.primaryGold,
          ),
          const SizedBox(width: 8),
          const Text(
            'SANTIAGO, CHILE | SANHATTAN',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),
      Text(
        'Protección Legal Integral para tu Empresa y Familia.',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: isMobile ? 36 : 56,
              fontWeight: FontWeight.bold,
            ),
      ),
      const SizedBox(height: 24),
      Text(
        'Prevenimos problemas legales estratégicamente y te defendemos judicialmente ante cualquier conflicto en curso. Combinamos experiencia técnica y tecnología para resguardar tu patrimonio.',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      const SizedBox(height: 40),
      Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          ElevatedButton(
            onPressed: onCtaPressed,
            child: const Text('AGENDAR ASESORÍA INMEDIATA'),
          ),
          OutlinedButton(
            onPressed: () {},
            child: const Text('VER ÁREAS DE PRÁCTICA'),
          ),
        ],
      ),
      if (isMobile) ...[
        const SizedBox(height: 48),
        Center(child: _buildPortraitWidget()),
      ]
    ];
  }

  Widget _buildPortraitWidget() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer.withOpacity(0.5),
        border: Border.all(color: AppTheme.outlineVariant, width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          color: AppTheme.surfaceContainerLow,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, color: AppTheme.primaryGold, size: 64),
                SizedBox(height: 12),
                Text(
                  'Socia Fundadora',
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Abogados Lama',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
