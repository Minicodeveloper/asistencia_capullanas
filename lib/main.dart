import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

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

        // Se irán agregando a medida que creemos cada pantalla:
        // AppRoutes.studentsList: (context) => const StudentsListScreen(),
        // AppRoutes.studentDetail: (context) => const StudentDetailScreen(),
        // AppRoutes.riskAnalysis: (context) => const RiskAnalysisScreen(),
        // AppRoutes.alerts: (context) => const AlertsScreen(),
        // AppRoutes.reports: (context) => const ReportsScreen(),
        // AppRoutes.communication: (context) => const CommunicationScreen(),
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

/// Nombres de ruta centralizados. Usar siempre estas constantes
/// en lugar de strings sueltos al navegar (Navigator.pushNamed(context, AppRoutes.login)).
class AppRoutes {
  AppRoutes._();

  static const String welcome = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String studentsList = '/students';
  static const String studentDetail = '/students/detail';
  static const String riskAnalysis = '/risk-analysis';
  static const String alerts = '/alerts';
  static const String reports = '/reports';
  static const String communication = '/communication';
  static const String closing = '/closing';
}