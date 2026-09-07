import 'package:flutter/material.dart';

enum RiskLevel { todos, alto, medio, bajo }

extension RiskLevelExtension on RiskLevel {
  String get label {
    switch (this) {
      case RiskLevel.todos:
        return 'Todos';
      case RiskLevel.alto:
        return 'Riesgo alto';
      case RiskLevel.medio:
        return 'Riesgo medio';
      case RiskLevel.bajo:
        return 'Riesgo bajo';
    }
  }

  Color get color {
    switch (this) {
      case RiskLevel.todos:
        return const Color(0xFF1565C0);
      case RiskLevel.alto:
        return const Color(0xFFC62828);
      case RiskLevel.medio:
        return const Color(0xFFE65100);
      case RiskLevel.bajo:
        return const Color(0xFF2E7D32);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case RiskLevel.todos:
        return const Color(0xFFE3F2FD);
      case RiskLevel.alto:
        return const Color(0xFFFFEBEE);
      case RiskLevel.medio:
        return const Color(0xFFFFF3E0);
      case RiskLevel.bajo:
        return const Color(0xFFE8F5E9);
    }
  }
}

/// Modelo de datos para representar a un estudiante en la lista.
class Student {
  final String id;
  final String name;
  final String grade;
  final RiskLevel risk;
  final String avatarUrl;
  final double attendancePercentage;
  final int tardinessCount;

  const Student({
    required this.id,
    required this.name,
    required this.grade,
    required this.risk,
    this.avatarUrl = '',
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
  int _currentTabIndex = 1; // 1 = Estudiantes
  RiskLevel _selectedRiskFilter = RiskLevel.todos;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Lista de datos simulados basada en el diseño del prototipo
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
        Navigator.of(context).pushReplacementNamed('/dashboard');
        break;
      case 1:
        // Ya estamos en Estudiantes.
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredStudents;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: const Text(
          'ALERTA EDUCATIVA IA',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            tooltip: 'Notificaciones',
            onPressed: () => Navigator.of(context).pushNamed('/alerts'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera superior "Mis estudiantes" y Buscador
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mis estudiantes',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 12),

                // Barra de Búsqueda
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar estudiante...',
                    hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
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
                    filled: true,
                    fillColor: const Color(0xFFF0F4F8),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Chips de Filtro por Nivel de Riesgo
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: RiskLevel.values.map((risk) {
                      final isSelected = _selectedRiskFilter == risk;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(risk.label),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedRiskFilter = risk;
                            });
                          },
                          selectedColor: const Color(0xFF1565C0),
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                          backgroundColor: const Color(0xFFE0E0E0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide.none,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Encabezado de la lista de columnas (Nombre, Grado, Riesgo)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            color: const Color(0xFFE8EAF6),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Nombre',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF3F51B5),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Grado',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF3F51B5),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Riesgo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF3F51B5),
                    ),
                  ),
                ),
                SizedBox(width: 24), // Espacio alineado para la flecha
              ],
            ),
          ),

          // Lista de estudiantes
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_search_outlined,
                            size: 60, color: Colors.black26),
                        SizedBox(height: 12),
                        Text(
                          'No se encontraron estudiantes',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
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

/// Elemento individual de estudiante para la lista
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF1565C0).withValues(alpha: 0.1),
              child: Text(
                student.name.isNotEmpty ? student.name[0] : 'E',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Nombre
            Expanded(
              flex: 3,
              child: Text(
                student.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),

            // Grado
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

            // Etiqueta de Nivel de Riesgo
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: student.risk.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  student.risk.label.replaceAll('Riesgo ', ''),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: student.risk.color,
                  ),
                ),
              ),
            ),

            // Flecha de navegación
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
