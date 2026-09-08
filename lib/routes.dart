/// Nombres de ruta centralizados de la app.
///
/// Vive en su propio archivo (y no dentro de main.dart) para que
/// cualquier pantalla pueda importar solo esto sin crear un import
/// circular con main.dart.
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