import 'package:flutter/material.dart';
import '../routes.dart';

class SentMessage {
  final String id;
  final String recipient;
  final String studentInfo;
  final String message;
  final String timestamp;

  const SentMessage({
    required this.id,
    required this.recipient,
    required this.studentInfo,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipient': recipient,
      'studentInfo': studentInfo,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory SentMessage.fromMap(Map<String, dynamic> map) {
    return SentMessage(
      id: map['id']?.toString() ?? '',
      recipient: map['recipient']?.toString() ?? '',
      studentInfo: map['studentInfo']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      timestamp: map['timestamp']?.toString() ?? '',
    );
  }
}

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  int _currentTabIndex = 0; // 0 = Nuevo Mensaje, 1 = Historial
  int _bottomNavIndex = 0;

  String _selectedRecipient = 'Padre/ Madre de Familia';
  String _selectedStudent = 'Maria Lopez - 5° B';

  final List<String> _recipients = const [
    'Padre/ Madre de Familia',
    'Estudiante',
    'Tutor',
  ];

  final List<String> _students = const [
    'Maria Lopez - 5° B',
    'Camila Torres - 4° A',
    'Lucia Garcia - 5° A',
    'Valeria Ruiz - 4° C',
  ];

  late TextEditingController _messageController;

  // TODO: Cargar historial de mensajes enviados desde la base de datos local (SQFlite/Isar/Firebase).
  final List<SentMessage> _historyMessages = [
    const SentMessage(
      id: '1',
      recipient: 'Padre/ Madre de Familia',
      studentInfo: 'Maria Lopez - 5° B',
      message:
          'Estimados padre de familia: Hemos detectado que Maria presenta inasistencias frecuentes y un descenso en su rendimiento academico. Les invitamos a una reunion para trabajar juntos en su bienestar escolar.',
      timestamp: 'Hoy - 10:30 a.m.',
    ),
    const SentMessage(
      id: '2',
      recipient: 'Padre/ Madre de Familia',
      studentInfo: 'Camila Torres - 4° A',
      message:
          'Estimado apoderado: Le informamos sobre el progreso positivo de Camila durante las últimas dos semanas en el curso de matemáticas.',
      timestamp: 'Ayer - 04:15 p.m.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(
      text:
          'Estimados padre de familia:\nHemos detectado que Maria presenta inasistencias frecuentes y un descenso en su rendimiento academico.Les invitamos a una reunion para trabajar juntos en su bienestar escolar.\n\n...',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      final name = args['studentName']?.toString();
      final grade = args['grade']?.toString();
      if (name != null && name.isNotEmpty) {
        final combo = grade != null ? '$name - $grade' : name;
        if (!_students.contains(combo)) {
          setState(() {
            _selectedStudent = combo;
          });
        } else {
          setState(() {
            _selectedStudent = combo;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un mensaje.')),
      );
      return;
    }

    final newMessage = SentMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      recipient: _selectedRecipient,
      studentInfo: _selectedStudent,
      message: _messageController.text.trim(),
      timestamp: 'Ahora mismo',
    );

    // TODO: Guardar en la base de datos persistente.
    setState(() {
      _historyMessages.insert(0, newMessage);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mensaje enviado exitosamente a la apoderada.'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }

  void _onBottomTabTapped(int index) {
    if (index == _bottomNavIndex) return;
    setState(() => _bottomNavIndex = index);

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
        Navigator.of(context).pushReplacementNamed(AppRoutes.reports);
        break;
    }
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
                  const SizedBox(width: 12),
                  const Text(
                    'COMUNICACION',
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

            // Pestañas Superiores (Nuevo Mensaje / Historial)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _currentTabIndex = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _currentTabIndex == 0
                              ? const Color(0xFF0038FF)
                              : const Color(0xFFD0F0FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Nuevo Mensaje',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: _currentTabIndex == 0
                                ? Colors.white
                                : const Color(0xFF0038FF),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _currentTabIndex = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _currentTabIndex == 1
                              ? const Color(0xFF0038FF)
                              : const Color(0xFFD0F0FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Historial',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: _currentTabIndex == 1
                                ? Colors.white
                                : const Color(0xFF0038FF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contenido según la pestaña
            Expanded(
              child: _currentTabIndex == 0
                  ? _buildNewMessageView()
                  : _buildHistoryView(),
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
              isSelected: _bottomNavIndex == 0,
              onTap: () => _onBottomTabTapped(0),
            ),
            _NavItem(
              icon: Icons.groups,
              label: 'Estudiantes',
              isSelected: _bottomNavIndex == 1,
              onTap: () => _onBottomTabTapped(1),
            ),
            _NavItem(
              icon: Icons.notifications,
              label: 'Alertas',
              isSelected: _bottomNavIndex == 2,
              onTap: () => _onBottomTabTapped(2),
            ),
            _NavItem(
              icon: Icons.bar_chart,
              label: 'Reportes',
              isSelected: _bottomNavIndex == 3,
              onTap: () => _onBottomTabTapped(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewMessageView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seleccionar destinatario
          const Text(
            'Seleccionar destinatario:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B365D),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black26),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedRecipient,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                style: const TextStyle(fontSize: 15, color: Colors.black54),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => _selectedRecipient = newValue);
                  }
                },
                items: _recipients.map((r) {
                  return DropdownMenuItem<String>(
                    value: r,
                    child: Text(r),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Seleccionar estudiante
          const Text(
            'Seleccionar estudiante:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B365D),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black26),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _students.contains(_selectedStudent)
                    ? _selectedStudent
                    : _students.first,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => _selectedStudent = newValue);
                  }
                },
                items: _students.map((s) {
                  return DropdownMenuItem<String>(
                    value: s,
                    child: Text(s),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Mensaje
          const Text(
            'Mensaje:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B365D),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black26),
            ),
            child: TextField(
              controller: _messageController,
              maxLines: 6,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Botón Enviar Mensaje (Estilo WhatsApp)
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _sendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_bubble_rounded,
                      color: Color(0xFF4CAF50),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Enviar mensaje',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHistoryView() {
    // TODO: Conectar proyección de la base de datos para recuperar el historial por estudiante o apoderado.
    if (_historyMessages.isEmpty) {
      return const Center(
        child: Text(
          'No hay mensajes enviados en el historial.',
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _historyMessages.length,
      itemBuilder: (context, index) {
        final msg = _historyMessages[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    msg.studentInfo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B365D),
                    ),
                  ),
                  Text(
                    msg.timestamp,
                    style: const TextStyle(fontSize: 11, color: Colors.black45),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Para: ${msg.recipient}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0038FF),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                msg.message,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
            ],
          ),
        );
      },
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
