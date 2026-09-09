import 'package:flutter/material.dart';
import '../routes.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _currentTabIndex = 3;
  String _selectedFilter = 'General';
  String _selectedSubGrade = '5°';
  String _selectedSubSection = 'Sección B';

  final List<String> _filters = const ['General', 'Por Grado', 'Por Sección'];
  final List<String> _grades = const ['1°', '2°', '3°', '4°', '5°'];
  final List<String> _sections = const ['Sección A', 'Sección B', 'Sección C'];

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
        Navigator.of(context).pushReplacementNamed(AppRoutes.alerts);
        break;
      case 3:
        break;
    }
  }

  void _downloadReport() {
    // TODO: conectar con servicio de exportación PDF/Excel desde la base de datos real.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generando y descargando reporte de $_selectedFilter...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Encabezado principal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFF80D8FF),
              child: Row(
                children: [
                  const Icon(
                    Icons.bar_chart_rounded,
                    color: Color(0xFF0038FF),
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/capullanas_logo.png',
                    height: 38,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.school_rounded,
                        size: 32,
                        color: Color(0xFF1565C0),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'REPORTES',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filtros superiores
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _filters.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _selectedFilter = filter);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF0038FF)
                                      : const Color(0xFFD0F0FF),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  filter,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF0038FF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Sub-filtro secundario según selección
                    if (_selectedFilter == 'Por Grado')
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _grades.map((grade) {
                            final isSel = _selectedSubGrade == grade;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text('Grado $grade'),
                                selected: isSel,
                                selectedColor: const Color(0xFF0038FF),
                                labelStyle: TextStyle(
                                  color: isSel ? Colors.white : const Color(0xFF1B365D),
                                  fontWeight: FontWeight.bold,
                                ),
                                onSelected: (sel) {
                                  if (sel) setState(() => _selectedSubGrade = grade);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    if (_selectedFilter == 'Por Sección')
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _sections.map((sec) {
                            final isSel = _selectedSubSection == sec;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(sec),
                                selected: isSel,
                                selectedColor: const Color(0xFF0038FF),
                                labelStyle: TextStyle(
                                  color: isSel ? Colors.white : const Color(0xFF1B365D),
                                  fontWeight: FontWeight.bold,
                                ),
                                onSelected: (sel) {
                                  if (sel) setState(() => _selectedSubSection = sec);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // Título dinámico
                    Text(
                      _getSectionTitle(_selectedFilter),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B365D),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Cuadrícula de métricas
                    _buildMetricsGrid(_selectedFilter),
                    const SizedBox(height: 24),

                    // Título del gráfico
                    Text(
                      _getChartTitle(_selectedFilter),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B365D),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Gráfico de barras apiladas
                    _RiskBarChartWidget(
                      filter: _selectedFilter,
                      subGrade: _selectedSubGrade,
                      subSection: _selectedSubSection,
                    ),
                    const SizedBox(height: 16),

                    // Leyenda de colores del gráfico
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ChartLegendItem(
                          color: Color(0xFF00E676),
                          label: 'Bajo',
                        ),
                        _ChartLegendItem(
                          color: Color(0xFFFFEA00),
                          label: 'Medio',
                        ),
                        _ChartLegendItem(
                          color: Color(0xFFFF1744),
                          label: 'Alto',
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Botón Descargar reporte
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _downloadReport,
                        icon: const Icon(
                          Icons.download_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        label: const Text(
                          'Descargar reporte',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0038FF),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
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

  String _getSectionTitle(String filter) {
    switch (filter) {
      case 'Por Grado':
        return 'Resumen - $_selectedSubGrade Grado';
      case 'Por Sección':
        return 'Resumen - $_selectedSubSection';
      default:
        return 'Resumen Institucional';
    }
  }

  String _getChartTitle(String filter) {
    switch (filter) {
      case 'Por Grado':
        return 'Nivel de riesgo en $_selectedSubGrade Grado';
      case 'Por Sección':
        return 'Nivel de riesgo en $_selectedSubSection';
      default:
        return 'Nivel de riesgo institucional por grado';
    }
  }

  Widget _buildMetricsGrid(String filter) {
    // TODO: conectar con repositorio/base de datos para calcular métricas reales según filtro.
    String attendance = '92%';
    String riskCount = '12';
    String improvement = '+ 8%';
    String totalStudents = '136';

    if (filter == 'Por Grado') {
      attendance = '91%';
      riskCount = '4';
      improvement = '+ 5%';
      totalStudents = '28';
    } else if (filter == 'Por Sección') {
      attendance = '94%';
      riskCount = '3';
      improvement = '+ 10%';
      totalStudents = '25';
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryMetricCard(
                value: attendance,
                label: 'Asistencia\npromedios',
                backgroundColor: const Color(0xFFE0F7FA),
                iconColor: const Color(0xFF0038FF),
                icon: Icons.person_search_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryMetricCard(
                value: riskCount,
                label: 'Estudiantes\nen riesgo',
                backgroundColor: const Color(0xFFFFEBEE),
                iconColor: const Color(0xFFE53935),
                icon: Icons.warning_amber_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SummaryMetricCard(
                value: improvement,
                label: 'Mejora vs.\nmes anterior',
                backgroundColor: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF2E7D32),
                icon: Icons.trending_up_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryMetricCard(
                value: totalStudents,
                label: 'Total de\nestudiantes',
                backgroundColor: const Color(0xFFF3E5F5),
                iconColor: const Color(0xFF7B1FA2),
                icon: Icons.groups_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryMetricCard extends StatelessWidget {
  final String value;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;

  const _SummaryMetricCard({
    required this.value,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B365D),
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.1,
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

class _RiskBarChartWidget extends StatelessWidget {
  final String filter;
  final String subGrade;
  final String subSection;

  const _RiskBarChartWidget({
    required this.filter,
    required this.subGrade,
    required this.subSection,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: consultar datos reales de distribución de riesgo desde la base de datos.
    List<Map<String, dynamic>> chartData;

    if (filter == 'Por Sección') {
      chartData = [
        {'label': 'Sec A', 'alto': 1.2, 'medio': 2.0, 'bajo': 3.5},
        {'label': 'Sec B', 'alto': 2.5, 'medio': 2.2, 'bajo': 2.8},
        {'label': 'Sec C', 'alto': 1.0, 'medio': 1.8, 'bajo': 4.0},
      ];
    } else if (filter == 'Por Grado') {
      chartData = [
        {'label': '$subGrade A', 'alto': 1.0, 'medio': 1.5, 'bajo': 3.0},
        {'label': '$subGrade B', 'alto': 2.0, 'medio': 1.2, 'bajo': 2.5},
        {'label': '$subGrade C', 'alto': 0.5, 'medio': 1.0, 'bajo': 3.8},
      ];
    } else {
      chartData = [
        {'label': '1°', 'alto': 0.3, 'medio': 1.5, 'bajo': 2.2},
        {'label': '2°', 'alto': 0.2, 'medio': 1.2, 'bajo': 1.6},
        {'label': '3°', 'alto': 1.5, 'medio': 1.8, 'bajo': 3.2},
        {'label': '4°', 'alto': 0.8, 'medio': 1.5, 'bajo': 2.2},
        {'label': '5°', 'alto': 2.0, 'medio': 1.5, 'bajo': 4.5},
      ];
    }

    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('8', style: TextStyle(fontSize: 11, color: Colors.black54)),
              Text('5', style: TextStyle(fontSize: 11, color: Colors.black54)),
              Text('3', style: TextStyle(fontSize: 11, color: Colors.black54)),
              Text('2', style: TextStyle(fontSize: 11, color: Colors.black54)),
              Text('0', style: TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    5,
                    (index) => const Divider(height: 1, color: Colors.black12),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: chartData.map((data) {
                    final alto = data['alto'] as double;
                    final medio = data['medio'] as double;
                    final bajo = data['bajo'] as double;
                    final total = alto + medio + bajo;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: filter == 'General' ? 38 : 52,
                          height: (total / 8.0) * 130,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: (bajo * 10).toInt(),
                                  child: Container(color: const Color(0xFF00E676)),
                                ),
                                Expanded(
                                  flex: (medio * 10).toInt(),
                                  child: Container(color: const Color(0xFFFFEA00)),
                                ),
                                Expanded(
                                  flex: (alto * 10).toInt(),
                                  child: Container(color: const Color(0xFFFF1744)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data['label'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B365D),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B365D),
          ),
        ),
      ],
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
