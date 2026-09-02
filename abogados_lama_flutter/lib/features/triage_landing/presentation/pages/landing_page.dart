import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_breakpoints.dart';
import '../../domain/usecases/submit_triage.dart';
import '../../data/datasources/remote_source.dart';
import '../state/triage_provider.dart';
import '../widgets/hero_section.dart';
import '../widgets/identity_section.dart';
import '../widgets/practice_card.dart';
import '../widgets/triage_modal.dart';
import '../widgets/footer.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late final TriageNotifier _triageNotifier;

  @override
  void initState() {
    super.initState();
    // Inject clean dependencies inline for standalone runtime stability
    final dataSource = TriageRemoteDataSourceImpl();
    final repository = TriageRepositoryImpl(dataSource);
    final useCase = SubmitTriage(repository);
    _triageNotifier = TriageNotifier(submitTriageUseCase: useCase);
  }

  @override
  void dispose() {
    _triageNotifier.dispose();
    super.dispose();
  }

  void _showTriageDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TriageModal(notifier: _triageNotifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = AppBreakpoints.isMobile(width);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72.0),
        child: Container(
          decoration: const BoxDecoration(
            color: AppTheme.primaryNavy,
            border: Border(
              bottom: BorderSide(color: AppTheme.outlineVariant, width: 1),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24.0 : 64.0,
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'LAMA',
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.primaryGold.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: const Text(
                        'ESTUDIO JURÍDICO',
                        style: TextStyle(
                          color: AppTheme.primaryGold,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!isMobile)
                  Row(
                    children: [
                      _buildHeaderNav('Inicio'),
                      const SizedBox(width: 32),
                      _buildHeaderNav('El Estudio'),
                      const SizedBox(width: 32),
                      _buildHeaderNav('Especialidades'),
                      const SizedBox(width: 32),
                      _buildHeaderNav('Trayectoria'),
                      const SizedBox(width: 40),
                      ElevatedButton(
                        onPressed: _showTriageDialog,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('AGENDAR ASESORÍA'),
                      ),
                    ],
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.menu, color: AppTheme.textLight),
                    onPressed: _showTriageDialog, // Triggers modal direct on mobile
                  ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(onCtaPressed: _showTriageDialog),
            const IdentitySection(),
            _buildPracticeGridSection(context, isMobile),
            _buildConfidentialCallout(context, isMobile),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderNav(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontFamily: 'Inter',
        color: AppTheme.textLight,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildPracticeGridSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24.0 : 64.0,
        vertical: 80.0,
      ),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                const Text(
                  'NUESTRAS SOLUCIONES',
                  style: TextStyle(
                    color: AppTheme.primaryGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Áreas de Especialización',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Un mapa completo de servicios para la prevención del riesgo y la defensa ante conflictos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 56),
          // Clean responsive layout calculation
          isMobile
              ? Column(
                  children: _buildPracticeCards(),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildPracticeCards()
                      .map((card) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: card,
                            ),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }

  List<Widget> _buildPracticeCards() {
    return [
      const PracticeCard(
        icon: Icons.domain_outlined,
        title: 'PYMES y Empresas',
        description:
            'Asesoría jurídica estratégica enfocada en la continuidad del negocio, mitigación de riesgos contractuales y cumplimiento del marco legal corporativo.',
        items: [
          {
            'label': 'Laboral y Seguridad:',
            'sub': 'Despidos, finiquitos, reclamaciones ante la Inspección del Trabajo y demandas laborales de alta complejidad.'
          },
          {
            'label': 'Ley Karin:',
            'sub': 'Elaboración de protocolos obligatorios, reglamentos internos y canal de denuncias. Prevención integral del acoso laboral.'
          },
          {
            'label': 'Compliance Penal:',
            'sub': 'Modelos de prevención bajo la nueva Ley de Delitos Económicos para mitigar riesgos penales y reputacionales de la administración.'
          },
          {
            'label': 'Mercado Público:',
            'sub': 'Postulaciones y adjudicaciones de licitaciones públicas del Estado, recursos ante el Tribunal de Contratación Pública.'
          },
        ],
      ),
      const PracticeCard(
        icon: Icons.family_restroom_outlined,
        title: 'Personas y Familia',
        description:
            'Asesoría y resguardo del patrimonio familiar, transacciones inmobiliarias de alta legibilidad, y planificación legal sucesoria.',
        items: [
          {
            'label': 'Bienes Raíces y Propiedades:',
            'sub': 'Estudios de títulos, escrituras de compraventa, contratos de arrendamiento complejos, usufructos e hipotecas.'
          },
          {
            'label': 'Defensa Financiera y Consumidor:',
            'sub': 'Defensa ante juicios de cobranza bancaria, embargos, fraudes financieros y demandas contra el Retail.'
          },
          {
            'label': 'Derecho Sucesorio:',
            'sub': 'Tramitación de posesiones efectivas (testadas e intestadas), partición de herencias y planificación hereditaria legal.'
          },
          {
            'label': 'Policía Local:',
            'sub': 'Representación en querellas por choques, accidentes de tránsito e infracciones a normativas municipales vigentes.'
          },
        ],
      ),
      const PracticeCard(
        icon: Icons.gavel_outlined,
        title: 'Litigios y Defensa',
        description:
            'Representación judicial de alto nivel y argumentación ante tribunales chilenos. Estrategias defensivas rigurosas orientadas a resultados concretos.',
        items: [
          {
            'label': 'Juicios Civiles y Comerciales:',
            'sub': 'Cobro de pesos, demandas de indemnización de perjuicios contractual y extracontractual, incumplimiento contractual.'
          },
          {
            'label': 'Instancias Superiores:',
            'sub': 'Estrategia, redacción e interposición de recursos de apelación y casación ante la Corte de Apelaciones y la Corte Suprema.'
          },
          {
            'label': 'Alegatos y Defensa Oral:',
            'sub': 'Sólida argumentación en estrados presenciales u online, con rigurosa preparación técnica y jurisprudencial.'
          },
        ],
      ),
    ];
  }

  Widget _buildConfidentialCallout(BuildContext context, bool isMobile) {
    final widgets = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ATENCIÓN CONFIDENCIAL',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inicie su Consulta Hoy',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Para su seguridad y comodidad, disponemos de sesiones presenciales en nuestras oficinas de Sanhattan o mediante videoconferencia encriptada. Active el asistente inteligente para evaluar la urgencia legal de su requerimiento.',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Icon(Icons.location_on, color: AppTheme.primaryGold, size: 18),
              SizedBox(width: 8),
              Text(
                'Las Condes, Santiago (Sanhattan)',
                style: TextStyle(color: AppTheme.textLight, fontSize: 13),
              ),
            ],
          )
        ],
      ),
      Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.quickreply, color: AppTheme.primaryGold, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Triage Legal Automatizado',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Evaluamos la urgencia, materia y viabilidad técnica de su caso legal en menos de 2 minutos para derivarlo al especialista indicado.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textMuted, fontSize: 12, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _showTriageDialog,
              child: const Text('INICIAR ASISTENTE DE TRIAGE'),
            )
          ],
        ),
      )
    ];

    return Container(
      color: AppTheme.surfaceContainer.withOpacity(0.3),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24.0 : 64.0,
        vertical: 80.0,
      ),
      child: isMobile
          ? Column(
              children: [
                widgets[0],
                const SizedBox(height: 48),
                widgets[1],
              ],
            )
          : Row(
              children: [
                Expanded(flex: 6, child: widgets[0]),
                const SizedBox(width: 64),
                Expanded(flex: 5, child: widgets[1]),
              ],
            ),
    );
  }
}
