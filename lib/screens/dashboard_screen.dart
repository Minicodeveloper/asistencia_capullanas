import 'package:flutter/material.dart';

class _StatCardData {
  final String value;
  final String label;
  final Color color;
  final IconData icon;

  const _StatCardData({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });
}

class _AlertItem {
  final String studentName;
  final String grade;
  final String description;
  final RiskLevel risk;

  const _AlertItem({
    required this.studentName,
    required this.grade,
    required this.description,
    required this.risk,
  });
}

enum RiskLevel { bajo, medio, alto }

extension RiskLevelStyle on RiskLevel {
  Color get color {
    switch (this) {
      case RiskLevel.bajo:
        return const Color(0xFF2E7D32);
      case RiskLevel.medio:
        return const Color(0xFFF9A825);
      case RiskLevel.alto:
        return const Color(0xFFC62828);
    }
  }

  String get label {
    switch (this) {
      case RiskLevel.bajo:
        return 'Riesgo bajo';
      case RiskLevel.medio:
        return 'Riesgo medio';
      case RiskLevel.alto:
        return 'Riesgo alto';
    }
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentTabIndex = 0;

  // TODO: reemplazar por datos reales desde la base de datos/API.
  final List<_AlertItem> _recentAlerts = const [
    _AlertItem(
      studentName: 'María Ruiz',
      grade: '5° B',
      description: 'Inasistencias frecuentes',
      risk: RiskLevel.alto,
    ),
    _AlertItem(
      studentName: 'Camila Torres',
      grade: '4° A',
      description: 'Bajo rendimiento académico',
      risk: RiskLevel.medio,
    ),
  ];

  final List<double> _attendanceTrend = const [
    0.55, 0.62, 0.58, 0.70, 0.68, 0.75, 0.72,
    0.80, 0.78, 0.85, 0.82, 0.90, 0.88, 0.92,
  ];

  static const int _totalStudents = 136;
  static const int _lowRiskCount = 98;
  static const int _mediumRiskCount = 26;
  static const int _highRiskCount = 12;

  void _onTabTapped(int index) {
    if (index == _currentTabIndex) return;
    setState(() => _currentTabIndex = index);

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/students');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/alerts');
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('/reports');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    String greetingName = '';

    if (args is Map) {
      if (args['user'] != null && args['user'].toString().trim().isNotEmpty) {
        greetingName = args['user'].toString().trim();
      } else if (args['role'] != null) {
        final roleStr = args['role'].toString();
        if (roleStr.contains('docente')) {
          greetingName = 'profesora!';
        } else if (roleStr.contains('tutor')) {
          greetingName = 'Tutor!';
        } else if (roleStr.contains('directivo')) {
          greetingName = 'Directivo!';
        } else if (roleStr.contains('padre')) {
          greetingName = 'Padre de Familia!';
        }
      }
    } else if (args != null) {
      final str = args.toString();
      if (str.contains('docente')) {
        greetingName = 'profesora!';
      }
    }

    final greeting = greetingName.isNotEmpty
        ? (greetingName.startsWith('¡') ? greetingName : '¡Hola, $greetingName!')
        : '¡Hola profesora!';

    final stats = <_StatCardData>[
      const _StatCardData(
        value: '$_totalStudents',
        label: 'Estudiantes\nmonitoreados',
        color: Color(0xFF1565C0),
        icon: Icons.groups_outlined,
      ),
      const _StatCardData(
        value: '$_lowRiskCount',
        label: 'Riesgo bajo',
        color: Color(0xFF2E7D32),
        icon: Icons.check_circle_outline,
      ),
      const _StatCardData(
        value: '$_mediumRiskCount',
        label: 'Riesgo medio',
        color: Color(0xFFF9A825),
        icon: Icons.warning_amber_outlined,
      ),
      const _StatCardData(
        value: '$_highRiskCount',
        label: 'Riesgo alto',
        color: Color(0xFFC62828),
        icon: Icons.error_outline,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        titleSpacing: 12,
        title: Row(
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: Image.asset(
                'assets/images/capullanas_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.shield_outlined,
                  color: Color(0xFF1565C0),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alerta Educativa',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Panel de control',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            tooltip: 'Notificaciones',
            onPressed: () => Navigator.of(context).pushNamed('/alerts'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: recargar datos desde el origen real.
          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              greeting,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Hoy cuidamos el futuro de nuestras estudiantes',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: stats.map((s) => _StatCard(data: s)).toList(),
            ),
            const SizedBox(height: 24),

            const Text(
              'Tendencia de asistencia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'Últimos 30 días',
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
            const SizedBox(height: 12),
            Container(
              height: 140,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: _attendanceTrend.isEmpty
                  ? const Center(
                      child: Text(
                        'Sin datos de asistencia aún',
                        style: TextStyle(color: Colors.black38, fontSize: 12),
                      ),
                    )
                  : CustomPaint(
                      size: Size.infinite,
                      painter: _TrendLinePainter(values: _attendanceTrend),
                    ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Alertas recientes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/alerts'),
                  child: const Text('Ver todas'),
                ),
              ],
            ),
            const SizedBox(height: 4),

            if (_recentAlerts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No hay alertas recientes',
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
              )
            else
              ..._recentAlerts.map((alert) => _AlertTile(alert: alert)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFD0F0FF),
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home,
              label: 'Inicio',
              isSelected: _currentTabIndex == 0,
              onTap: () => _onTabTapped(0),
            ),
            _NavItem(
              icon: Icons.groups,
              label: 'Estudiantes',
              isSelected: _currentTabIndex == 1,
              onTap: () => _onTabTapped(1),
            ),
            _NavItem(
              icon: Icons.notifications,
              label: 'Alertas',
              isSelected: _currentTabIndex == 2,
              onTap: () => _onTabTapped(2),
            ),
            _NavItem(
              icon: Icons.bar_chart,
              label: 'Reportes',
              isSelected: _currentTabIndex == 3,
              onTap: () => _onTabTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendLinePainter extends CustomPainter {
  final List<double> values;

  _TrendLinePainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final linePaint = Paint()
      ..color = const Color(0xFF1565C0)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()..color = const Color(0xFF1565C0);

    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = (maxValue - minValue).abs() < 0.0001
        ? 1.0
        : maxValue - minValue;

    final stepX = size.width / (values.length - 1);
    final points = <Offset>[];

    for (var i = 0; i < values.length; i++) {
      final normalized = (values[i] - minValue) / range;
      final x = i * stepX;
      final y = size.height - (normalized * size.height);
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, linePaint);

    for (final point in points) {
      canvas.drawCircle(point, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendLinePainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

class _StatCard extends StatelessWidget {
  final _StatCardData data;

  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(data.icon, color: data.color, size: 22),
          const SizedBox(height: 6),
          Text(
            data.value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: data.color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final _AlertItem alert;

  const _AlertTile({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: alert.risk.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: alert.risk.color, width: 4)),
      ),
      child: Row(
        children: [
          Icon(
            alert.risk == RiskLevel.alto
                ? Icons.error
                : Icons.warning_amber_rounded,
            color: alert.risk.color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${alert.studentName} — ${alert.grade}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${alert.risk.label} · ${alert.description}',
                  style: TextStyle(
                    fontSize: 12,
                    color: alert.risk.color,
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

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? const Color(0xFF0038FF) : Colors.black45;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
