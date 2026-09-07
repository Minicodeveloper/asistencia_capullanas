import 'package:flutter/material.dart';

/// Modelo simple para una tarjeta de estadística del dashboard.
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

/// Modelo simple para un item de alerta reciente.
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

/// Panel principal: resumen de estudiantes monitoreados, niveles de riesgo,
/// tendencia de asistencia y alertas recientes.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentTabIndex = 0;

  // TODO: reemplazar por datos reales desde el repositorio/servicio
  // correspondiente (API, base de datos local, etc.).
  final List<_AlertItem> _recentAlerts = const [
    _AlertItem(
      studentName: 'María López',
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

  static const int _totalStudents = 0;
  static const int _lowRiskCount = 0;
  static const int _mediumRiskCount = 0;
  static const int _highRiskCount = 0;

  void _onTabTapped(int index) {
    if (index == _currentTabIndex) return;
    setState(() => _currentTabIndex = index);

    // Las demás pantallas del flujo se registrarán en main.dart
    // a medida que se vayan construyendo.
    switch (index) {
      case 0:
      // Ya estamos en el dashboard.
        break;
      case 1:
        Navigator.of(context).pushNamed('/students');
        break;
      case 2:
        Navigator.of(context).pushNamed('/alerts');
        break;
      case 3:
        Navigator.of(context).pushNamed('/reports');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = <_StatCardData>[
      _StatCardData(
        value: '$_totalStudents',
        label: 'Estudiantes\nmonitoreados',
        color: const Color(0xFF1565C0),
        icon: Icons.groups_outlined,
      ),
      _StatCardData(
        value: '$_lowRiskCount',
        label: 'Riesgo bajo',
        color: const Color(0xFF2E7D32),
        icon: Icons.check_circle_outline,
      ),
      _StatCardData(
        value: '$_mediumRiskCount',
        label: 'Riesgo medio',
        color: const Color(0xFFF9A825),
        icon: Icons.warning_amber_outlined,
      ),
      _StatCardData(
        value: '$_highRiskCount',
        label: 'Riesgo alto',
        color: const Color(0xFFC62828),
        icon: Icons.error_outline,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de control'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
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
            const Text(
              '¡Hola!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Hoy cuidamos el futuro de nuestros estudiantes',
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: const Center(
                child: Text(
                  'Gráfico de asistencia\n(pendiente de conectar a datos reales)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black38, fontSize: 12),
                ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: Colors.black45,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Estudiantes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Reportes',
          ),
        ],
      ),
    );
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
        color: data.color.withOpacity(0.08),
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
        color: alert.risk.color.withOpacity(0.08),
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