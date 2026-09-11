import 'package:flutter/material.dart';

enum RiskLevel { todos, alto, medio, bajo }

extension RiskLevelStyle on RiskLevel {
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

  String get badgeText {
    switch (this) {
      case RiskLevel.todos:
        return 'Todos';
      case RiskLevel.alto:
        return 'Alto';
      case RiskLevel.medio:
        return 'Medio';
      case RiskLevel.bajo:
        return 'Bajo';
    }
  }

  Color get badgeColor {
    switch (this) {
      case RiskLevel.todos:
        return const Color(0xFF0038FF);
      case RiskLevel.alto:
        return const Color(0xFFFF1744);
      case RiskLevel.medio:
        return const Color(0xFFFFEA00);
      case RiskLevel.bajo:
        return const Color(0xFF00E676);
    }
  }

  Color get textColor {
    switch (this) {
      case RiskLevel.medio:
        return Colors.white;
      default:
        return Colors.white;
    }
  }
}

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'risk': risk.name,
      'attendancePercentage': attendancePercentage,
      'tardinessCount': tardinessCount,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      grade: map['grade']?.toString() ?? '',
      risk: RiskLevel.values.firstWhere(
        (r) => r.name == map['risk'],
        orElse: () => RiskLevel.bajo,
      ),
      attendancePercentage: (map['attendancePercentage'] as num?)?.toDouble() ?? 0.0,
      tardinessCount: (map['tardinessCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class StudentsListScreen extends StatefulWidget {
  const StudentsListScreen({super.key});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  int _currentTabIndex = 1;
  RiskLevel _selectedRiskFilter = RiskLevel.todos;
  String _selectedGradeFilter = 'Todos';
  String _selectedSectionFilter = 'Todas';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Student> _allStudents = const [
    Student(
      id: '1',
      name: 'Maria Lopez',
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
      name: 'Lucia Garcia',
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
      name: 'Sofia Mendoza',
      grade: '4° B',
      risk: RiskLevel.bajo,
      attendancePercentage: 96.0,
      tardinessCount: 0,
    ),
  ];

  List<Student> get _filteredStudents {
    return _allStudents.where((student) {
      final matchesSearch = student.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          student.grade.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesRisk = _selectedRiskFilter == RiskLevel.todos ||
          student.risk == _selectedRiskFilter;

      final matchesGrade = _selectedGradeFilter == 'Todos' ||
          student.grade.startsWith(_selectedGradeFilter);

      final matchesSection = _selectedSectionFilter == 'Todas' ||
          student.grade.endsWith(_selectedSectionFilter);

      return matchesSearch && matchesRisk && matchesGrade && matchesSection;
    }).toList();
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filtros por Grado y Sección',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B365D),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Grado:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Todos', '1°', '2°', '3°', '4°', '5°'].map((g) {
                      final isSel = _selectedGradeFilter == g;
                      return ChoiceChip(
                        label: Text(g),
                        selected: isSel,
                        selectedColor: const Color(0xFF0038FF),
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : Colors.black87,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {});
                            setState(() => _selectedGradeFilter = g);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sección:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Todas', 'A', 'B', 'C'].map((s) {
                      final isSel = _selectedSectionFilter == s;
                      return ChoiceChip(
                        label: Text(s),
                        selected: isSel,
                        selectedColor: const Color(0xFF0038FF),
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : Colors.black87,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {});
                            setState(() => _selectedSectionFilter = s);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0038FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Aplicar Filtros', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onTabTapped(int index) {
    if (index == _currentTabIndex) return;
    setState(() => _currentTabIndex = index);

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/dashboard');
        break;
      case 1:
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra superior (Top Bar)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: const Color(0xFF80D8FF),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFF0038FF), size: 32),
                    onPressed: () {},
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
                    icon: const Icon(Icons.notifications, color: Colors.black, size: 32),
                    onPressed: () => Navigator.of(context).pushNamed('/alerts'),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mis estudiantes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B365D),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Buscador + Botón Filtro
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() => _searchQuery = value);
                            },
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              hintText: 'Buscar estudiante......',
                              hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                              prefixIcon: Icon(Icons.search, color: Colors.black, size: 24),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _openFilterBottomSheet,
                        child: Container(
                          height: 42,
                          width: 44,
                          decoration: BoxDecoration(
                            color: (_selectedGradeFilter != 'Todos' || _selectedSectionFilter != 'Todas')
                                ? const Color(0xFF0038FF)
                                : const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.tune,
                            color: (_selectedGradeFilter != 'Todos' || _selectedSectionFilter != 'Todas')
                                ? Colors.white
                                : Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Chips de filtro por riesgo
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: RiskLevel.values.map((risk) {
                        final isSelected = _selectedRiskFilter == risk;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedRiskFilter = risk);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF0038FF)
                                    : const Color(0xFFE0E0E0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                risk.label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : const Color(0xFF1565C0),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Encabezado de la tabla
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFD0F0FF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Nombre',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF0038FF),
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
                        fontSize: 15,
                        color: Color(0xFF0038FF),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Riesgo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF0038FF),
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                ],
              ),
            ),

            // Lista de estudiantes
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No se encontraron estudiantes',
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          color: Colors.black26,
                        ),
                        itemBuilder: (context, index) {
                          final student = filtered[index];
                          return _StudentRowTile(
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
            ),
            const SizedBox(height: 10),
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

class _StudentRowTile extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;

  const _StudentRowTile({
    required this.student,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black87, width: 2),
                color: Colors.white,
              ),
              child: const Icon(
                Icons.person,
                size: 32,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              flex: 4,
              child: Text(
                student.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF1B365D),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Text(
                student.grade,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: student.risk.badgeColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    student.risk.badgeText,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: student.risk.textColor,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              color: Colors.black,
              size: 28,
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
