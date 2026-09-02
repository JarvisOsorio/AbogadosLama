import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_breakpoints.dart';

class IdentitySection extends StatelessWidget {
  const IdentitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = AppBreakpoints.isMobile(width);

    return Container(
      color: AppTheme.surfaceContainerLow,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24.0 : 64.0,
        vertical: 64.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile) ...[
            _buildIntro(context),
            const SizedBox(height: 48),
            _buildCards(),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _buildIntro(context),
                ),
                const SizedBox(width: 48),
                Expanded(
                  flex: 7,
                  child: _buildCards(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EXCELENCIA JURÍDICA',
          style: TextStyle(
            color: AppTheme.primaryGold,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Un Estudio Jurídico Moderno y Confiable',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 64,
          height: 3,
          color: AppTheme.primaryGold,
        ),
        const SizedBox(height: 24),
        Text(
          'En Abogados Lama, unimos la excelencia de la abogacía tradicional con la agilidad y precisión de herramientas tecnológicas avanzadas. Nuestro enfoque corporativo y personal en Sanhattan está diseñado para resolver la complejidad legal de manera clara, transparente y asertiva.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildCards() {
    return Column(
      children: [
        _buildInfoCard(
          icon: Icons.visibility_outlined,
          title: 'Nuestra Misión',
          desc:
              'Brindar asesoría jurídica estratégica, clara y eficiente, enfocada en la prevención y resolución de conflictos, la correcta gestión contractual y el estricto cumplimiento normativo, reduciendo riesgos mediante la innovación operativa.',
        ),
        const SizedBox(height: 24),
        _buildInfoCard(
          icon: Icons.military_tech_outlined,
          title: 'Nuestra Visión',
          desc:
              'Consolidarnos como un estudio jurídico de referencia y alto prestigio, reconocido por entregar soluciones rigurosas, prácticas y orientadas a resguardar la sostenibilidad del patrimonio de personas y empresas.',
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer.withOpacity(0.4),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.1), width: 1),
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryGold, size: 32),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Playfair Display',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
