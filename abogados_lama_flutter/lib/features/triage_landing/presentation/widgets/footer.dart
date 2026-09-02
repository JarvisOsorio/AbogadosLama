import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_breakpoints.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = AppBreakpoints.isMobile(width);

    return Container(
      color: AppTheme.primaryNavy,
      border: const Border(top: BorderSide(color: AppTheme.outlineVariant, width: 1)),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24.0 : 64.0,
        vertical: 48.0,
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildContent(context),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildContent(context),
            ),
    );
  }

  List<Widget> _buildContent(BuildContext context) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ABOGADOS LAMA',
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '© 2026 Abogados Lama. Excelencia Jurídica y Compromiso Ético.',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          _buildLink('Términos'),
          const SizedBox(width: 24),
          _buildLink('Privacidad'),
          const SizedBox(width: 24),
          _buildLink('Portal Interno'),
        ],
      )
    ];
  }

  Widget _buildLink(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
