import 'package:flutter/material.dart';
import 'students_list_screen.dart' show Student;

class StudentDetailScreen extends StatefulWidget {
  const StudentDetailScreen({super.key});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  String _selectedTab = 'Resumen';
  final List<String> _tabs = const ['Resumen', 'Detalle', 'Historial'];

  @override
  Widget build(BuildContext context) {
    // Obtiene los datos del estudiante pasados por la ruta si existen, o usa los valores por defecto.
    final studentArg = ModalRoute.of(context)?.settings.arguments;
    Student? student;
    if (studentArg is Student) {
      student = studentArg;
    }

    final String studentName = student != null ? '${student.name} Ruiz' : 'Maria Lopez Ruiz';
    final String studentGrade = student != null ? '${student.grade} - Secundaria' : '5° B - Secundaria';
    final String attendance = student != null ? '${student.attendancePercentage.toInt()}%' : '78%';
    final String tardiness = student != null ? '${student.tardinessCount}' : '6';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior de encabezado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: const Color(0xFF80D8FF),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 26),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 4),
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
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'ALERTA EDUCATIVA',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_rounded, color: Color(0xFF0038FF), size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  children: [
                    // Título Perfil del estudiante
                    const Text(
                      'Perfil del estudiante',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B365D),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Avatar circular del estudiante
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE0E0E0),
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Nombre y Grado
                    Text(
                      studentName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0038FF),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      studentGrade,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B365D),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Pestañas (Resumen, Detalle, Historial)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _tabs.map((tab) {
                        final isSelected = _selectedTab == tab;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _selectedTab = tab);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF0038FF)
                                      : const Color(0xFFD0F0FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  tab,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF1B365D),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Cuadrícula 2x2 de métricas
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.calendar_month_rounded,
                            label: 'Asistencia',
                            value: attendance,
                            valueColor: const Color(0xFF0038FF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.access_time_filled_rounded,
                            label: 'Tardanza',
                            value: tardiness,
                            valueColor: const Color(0xFF0038FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    const Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.show_chart_rounded,
                            label: 'Promedio',
                            value: '13.2',
                            valueColor: Color(0xFF0038FF),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.groups_rounded,
                            label: 'Participacion',
                            value: 'Baja',
                            valueColor: Color(0xFFFF1744),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Título Evolución de Rendimiento
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Evolucion de Rendimiento',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B365D),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Gráfico de línea de rendimiento
                    const _PerformanceLineChart(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0038FF), size: 36),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B365D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
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

class _PerformanceLineChart extends StatelessWidget {
  const _PerformanceLineChart();

  @override
  Widget build(BuildContext context) {
    const months = ['Marzo', 'Abril', 'Mayo', 'Junio', 'Julio'];

    return Container(
      height: 160,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Stack(
        children: [
          // Grid lines horizontales y verticales
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (index) => const Divider(height: 1, color: Colors.black26),
            ),
          ),

          // Línea de tendencia inclinada descendente y puntos rojos
          CustomPaint(
            size: const Size(double.infinity, 120),
            painter: _LineChartPainter(),
          ),

          // Etiqueta '0' en el eje Y inferior
          const Positioned(
            left: 0,
            bottom: 22,
            child: Text(
              '0',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Meses en el eje X
          Positioned(
            left: 10,
            right: 10,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: months.map((month) {
                return Text(
                  month,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B365D),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF0038FF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = const Color(0xFFFF1744)
      ..style = PaintingStyle.fill;

    final points = [
      Offset(20, size.height * 0.1),
      Offset(size.width * 0.26, size.height * 0.32),
      Offset(size.width * 0.50, size.height * 0.52),
      Offset(size.width * 0.74, size.height * 0.70),
      Offset(size.width - 20, size.height * 0.88),
    ];

    // Dibuja las líneas entre puntos
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], linePaint);
    }

    // Dibuja los puntos rojos
    for (final point in points) {
      canvas.drawCircle(point, 7.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
