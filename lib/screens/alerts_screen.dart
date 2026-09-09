import 'package:flutter/material.dart';
import '../routes.dart';

/// Filtros disponibles en la parte superior de la pantalla.
enum AlertFilter { todos, riesgoAlto, riesgoMedio }

extension AlertFilterLabel on AlertFilter {
  String get label {
    switch (this) {
      case AlertFilter.todos:
        return 'Todos';
      case AlertFilter.riesgoAlto:
        return 'Riesgo Alto';
      case AlertFilter.riesgoMedio:
        return 'Riesgo Medio';
    }
  }
}

/// Tipo de alerta: define el color, el ícono y a qué filtro pertenece.
enum AlertKind { riesgoAlto, riesgoMedio, mejora }

extension AlertKindStyle on AlertKind {
  Color get color {
    switch (this) {
      case AlertKind.riesgoAlto:
        return const Color(0xFFE53935);
      case AlertKind.riesgoMedio:
        return const Color(0xFFF5C518);
      case AlertKind.mejora:
        return const Color(0xFF1565C0);
    }
  }

  IconData get icon {
    switch (this) {
      case AlertKind.riesgoAlto:
      case AlertKind.riesgoMedio:
        return Icons.error;
      case AlertKind.mejora:
        return Icons.notifications;
    }
  }

  String get label {
    switch (this) {
      case AlertKind.riesgoAlto:
        return 'Riesgo alto de deserción';
      case AlertKind.riesgoMedio:
        return 'Riesgo medio';
      case AlertKind.mejora:
        return 'Mejora en su rendimiento';
    }
  }

  AlertFilter? get filter {
    switch (this) {
      case AlertKind.riesgoAlto:
        return AlertFilter.riesgoAlto;
      case AlertKind.riesgoMedio:
        return AlertFilter.riesgoMedio;
      case AlertKind.mejora:
        return null; // Solo aparece dentro de "Todos".
    }
  }
}

/// Modelo simple para una alerta del centro de alertas.
class _AlertData {
  final String studentName;
  final String grade;
  final AlertKind kind;
  final String description;
  final String timestamp;

  const _AlertData({
    required this.studentName,
    required this.grade,
    required this.kind,
    required this.description,
    required this.timestamp,
  });
}

/// Pantalla 6: Centro de Alertas
/// Lista todas las alertas generadas por el sistema, con filtro por nivel
/// de riesgo.
class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int _currentTabIndex = 2;
  AlertFilter _selectedFilter = AlertFilter.todos;

  // TODO: reemplazar por datos reales desde el repositorio/servicio
  // correspondiente (API, base de datos local, etc.).
  final List<_AlertData> _allAlerts = const [
    _AlertData(
      studentName: 'María López',
      grade: '5°B',
      kind: AlertKind.riesgoAlto,
      description: 'Inasistencias frecuentes',
      timestamp: 'Hoy - 8:30 a.m.',
    ),
    _AlertData(
      studentName: 'Camila Torres',
      grade: '4°A',
      kind: AlertKind.riesgoMedio,
      description: 'Bajo rendimiento académico',
      timestamp: 'Hoy - 10:15 a.m.',
    ),
    _AlertData(
      studentName: 'Andrea Sánchez',
      grade: '5°A',
      kind: AlertKind.riesgoMedio,
      description: 'Tardanzas constantes',
      timestamp: 'Ayer - 4:30 p.m.',
    ),
    _AlertData(
      studentName: 'Lucía García',
      grade: '4°C',
      kind: AlertKind.mejora,
      description: 'Asistencia aumentó al 95%',
      timestamp: 'Ayer - 11:50 a.m.',
    ),
  ];

  List<_AlertData> get _filteredAlerts {
    if (_selectedFilter == AlertFilter.todos) return _allAlerts;
    return _allAlerts
        .where((alert) => alert.kind.filter == _selectedFilter)
        .toList();
  }

  void _onTabTapped(int index) {
    if (index == _currentTabIndex) return;
    setState(() => _currentTabIndex = index);

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(AppRoutes.studentsList);
        break;
      case 2:
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed(AppRoutes.reports);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final alerts = _filteredAlerts;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: const [
            Icon(Icons.notifications, size: 22),
            SizedBox(width: 8),
            Text(
              'CENTRO DE ALERTAS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF90CAF9),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: recargar alertas desde el origen real.
          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: AlertFilter.values.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(filter.label),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedFilter = filter);
                          }
                        },
                        backgroundColor: const Color(0xFFE3F2FD),
                        selectedColor: const Color(0xFF1565C0),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1565C0),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide.none,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: alerts.isEmpty
                  ? const Center(
                child: Text(
                  'No hay alertas para este filtro',
                  style: TextStyle(color: Colors.black45),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  return _AlertCard(alert: alerts[index]);
                },
              ),
            ),
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

class _AlertCard extends StatelessWidget {
  final _AlertData alert;

  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: alert.kind.color,
            child: Icon(alert.kind.icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${alert.studentName} - ${alert.grade}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  alert.kind.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: alert.kind.color == const Color(0xFFF5C518)
                        ? const Color(0xFFB8860B)
                        : alert.kind.color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  alert.description,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  alert.timestamp,
                  style: const TextStyle(fontSize: 11, color: Colors.black38),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}