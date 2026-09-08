import 'package:flutter/material.dart';

enum RiskLevel { todos, bajo, medio, alto }

extension RiskLevelStyle on RiskLevel {
  Color get color {
    switch (this) {
      case RiskLevel.todos:
        return const Color(0xFF1565C0);
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
      case RiskLevel.todos:
        return 'Todos';
      case RiskLevel.bajo:
        return 'Riesgo bajo';
      case RiskLevel.medio:
        return 'Riesgo medio';
      case RiskLevel.alto:
        return 'Riesgo alto';
    }
  }
}

/// Modelo de datos para representar a un estudiante en la lista.
class Student {
  final String id;
  final String name;
  final String grade;
  final RiskLevel risk;
  final double attendancePercentage;
  final int tardinessCount;

  const Student({
    required this.id,
    required this.name,
    required this.grade,
    required this.risk,
    required this.attendancePercentage,
    required this.tardinessCount,
  });
}

/// Pantalla 4: Lista de Estudiantes
/// Permite buscar, filtrar por nivel de riesgo y acceder al perfil individual.
class StudentsListScreen extends StatefulWidget {
  const StudentsListScreen({super.key});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  int _currentTabIndex = 1;
  RiskLevel _selectedRiskFilter = RiskLevel.todos;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // TODO: reemplazar por datos reales desde la base de datos o servicio correspondiente.
  // Aquí se deberían insertar los datos faltantes recuperados del repositorio de datos.
  final List<Student> _allStudents = const [
    Student(
      id: '1',
      name: 'María López',
      grade: '5° B',
      risk: RiskLevel.alto,
      attendancePercentage: 78.0,
      tardinessCount: 6,
    ),
    Student(
      id: '2',
      name: 'Camila Torres',
      grade: '4° A',
      risk: RiskLevel.medio,
      attendancePercentage: 85.0,
      tardinessCount: 3,
    ),
    Student(
      id: '3',
      name: 'Lucía García',
      grade: '5° A',
      risk: RiskLevel.bajo,
      attendancePercentage: 95.0,
      tardinessCount: 1,
    ),
    Student(
      id: '4',
      name: 'Valeria Ruiz',
      grade: '4° C',
      risk: RiskLevel.bajo,
      attendancePercentage: 92.0,
      tardinessCount: 2,
    ),
    Student(
      id: '5',
      name: 'Daniela Flores',
      grade: '5° B',
      risk: RiskLevel.medio,
      attendancePercentage: 84.0,
      tardinessCount: 4,
    ),
    Student(
      id: '6',
      name: 'Sofía Mendoza',
      grade: '4° B',
      risk: RiskLevel.bajo,
      attendancePercentage: 96.0,
      tardinessCount: 0,
    ),
    Student(
      id: '7',
      name: 'Andrea Sánchez',
      grade: '5° A',
      risk: RiskLevel.medio,
      attendancePercentage: 82.0,
      tardinessCount: 5,
    ),
    Student(
      id: '8',
      name: 'Carlos Ramírez',
      grade: '3° B',
      risk: RiskLevel.alto,
      attendancePercentage: 74.0,
      tardinessCount: 8,
    ),
  ];

  List<Student> get _filteredStudents {
    return _allStudents.where((student) {
      final matchesSearch = student.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          student.grade.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesFilter = _selectedRiskFilter == RiskLevel.todos ||
          student.risk == _selectedRiskFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _onTabTapped(int index) {
    if (index == _currentTabIndex) return;
    setState(() => _currentTabIndex = index);

    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/dashboard');
        break;
      case 1:
        // Ya se encuentra en la pantalla de estudiantes.
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Se añadirá en un futuro la consulta asíncrona a la base de datos local o remota.
    final filtered = _filteredStudents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ALERTA EDUCATIVA IA'),
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
          // TODO: recargar datos desde el origen real (base de datos o API).
          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mis estudiantes',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Listado y monitoreo de riesgo académico',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),

                  // Campo de búsqueda
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Buscar estudiante...',
                      hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF1565C0)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : const Icon(Icons.tune_outlined, color: Colors.black45),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filtros por nivel de riesgo
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: RiskLevel.values.map((risk) {
                        final isSelected = _selectedRiskFilter == risk;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(risk.label),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedRiskFilter = risk);
                              }
                            },
                            selectedColor: risk.color.withValues(alpha: 0.15),
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? risk.color : Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Encabezado de la tabla de estudiantes
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.black.withValues(alpha: 0.04),
              child: const Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Nombre',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Grado',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Riesgo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                ],
              ),
            ),

            // Lista filtrada
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text(
                        'No se encontraron estudiantes',
                        style: TextStyle(color: Colors.black45, fontSize: 14),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Colors.black12,
                      ),
                      itemBuilder: (context, index) {
                        final student = filtered[index];
                        return _StudentTile(
                          student: student,
                          onTap: () {
                            // TODO: Se añadirá en un futuro el paso de parámetros a la pantalla de detalle del estudiante.
                            Navigator.of(context).pushNamed(
                              '/students/detail',
                              arguments: student,
                            );
                          },
                        );
                      },
                    ),
            ),
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

extension on Color {
  withValues({required double alpha}) {}
}

class _StudentTile extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;

  const _StudentTile({
    required this.student,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF1565C0).withValues(alpha: 0.1),
              child: Text(
                student.name.isNotEmpty ? student.name[0] : 'E',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF1565C0),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 4,
              child: Text(
                student.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                student.grade,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: student.risk.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    student.risk.label.replaceAll('Riesgo ', ''),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: student.risk.color,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: Colors.black38,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
