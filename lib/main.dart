import 'package:flutter/material.dart';
import 'routes.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/students_list_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/student_detail_screen.dart';
import 'screens/communication_screen.dart';

void main() {
  runApp(const AlertaEducativaApp());
}

class AlertaEducativaApp extends StatelessWidget {
  const AlertaEducativaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alerta Educativa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1565C0),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (context) => const WelcomeScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.dashboard: (context) => const DashboardScreen(),
        AppRoutes.studentsList: (context) => const StudentsListScreen(),
        AppRoutes.alerts: (context) => const AlertsScreen(),
        AppRoutes.reports: (context) => const ReportsScreen(),
        AppRoutes.studentDetail: (context) => const StudentDetailScreen(),
        AppRoutes.communication: (context) => const CommunicationScreen(),

        // Se irán agregando a medida que creemos cada pantalla:
        // AppRoutes.riskAnalysis: (context) => const RiskAnalysisScreen(),
        // AppRoutes.closing: (context) => const ClosingScreen(),
      },
      // Ruta de respaldo si se navega a un nombre no registrado.
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        );
      },
    );
  }
}