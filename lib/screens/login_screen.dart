import 'package:flutter/material.dart';
import '../routes.dart';

enum UserRole { docente, tutor, directivo, padreDeFamilia }

extension UserRoleDetails on UserRole {
  String get label {
    switch (this) {
      case UserRole.docente:
        return 'Docente';
      case UserRole.tutor:
        return 'Tutor';
      case UserRole.directivo:
        return 'Directivo';
      case UserRole.padreDeFamilia:
        return 'Padre\nde Familia';
    }
  }

  String get assetPath {
    switch (this) {
      case UserRole.docente:
        return 'assets/images/docente.png';
      case UserRole.tutor:
        return 'assets/images/tutor.png';
      case UserRole.directivo:
        return 'assets/images/directivo.png';
      case UserRole.padreDeFamilia:
        return 'assets/images/padre_de_familia.png';
    }
  }

  IconData get fallbackIcon {
    switch (this) {
      case UserRole.docente:
        return Icons.co_present_rounded;
      case UserRole.tutor:
        return Icons.groups_rounded;
      case UserRole.directivo:
        return Icons.badge_rounded;
      case UserRole.padreDeFamilia:
        return Icons.family_restroom_rounded;
    }
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  UserRole _selectedRole = UserRole.docente;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu usuario o correo';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu contraseña';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo iniciar sesión. Intenta nuevamente.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF80D8FF),
              Color(0xFF4FC3F7),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo de la institución
                    Image.asset(
                      'assets/images/capullanas_logo.png',
                      height: 110,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            size: 56,
                            color: Color(0xFF1565C0),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // Título Alerta Educativa IA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Alerta Educativa ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF81D4FA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'IA',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    const Text(
                      'Bienvenida',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),

                    const Text(
                      'Inicia Sesion',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Campo de Usuario o correo
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 15),
                        decoration: const InputDecoration(
                          hintText: 'Usuario o correo',
                          hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 16, right: 10),
                            child: Icon(Icons.person, color: Colors.black87, size: 24),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                        validator: _validateEmail,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Campo de Contraseña
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'Contraseña',
                          hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 16, right: 10),
                            child: Icon(Icons.lock, color: Colors.black87, size: 24),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                        validator: _validatePassword,
                        onFieldSubmitted: (_) => _handleLogin(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Botón Ingresar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0038FF),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Ingresar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Enlace Olvidaste tu contraseña
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Contacta al administrador del sistema.'),
                          ),
                        );
                      },
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          color: Color(0xFF0038FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Título Selección de rol
                    const Text(
                      'Selecciona tu rol:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D1B2A),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Tarjetas de Selección de Rol (2x2 Grid)
                    Row(
                      children: [
                        Expanded(
                          child: _RoleCard(
                            role: UserRole.docente,
                            isSelected: _selectedRole == UserRole.docente,
                            onTap: () => setState(() => _selectedRole = UserRole.docente),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _RoleCard(
                            role: UserRole.tutor,
                            isSelected: _selectedRole == UserRole.tutor,
                            onTap: () => setState(() => _selectedRole = UserRole.tutor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _RoleCard(
                            role: UserRole.directivo,
                            isSelected: _selectedRole == UserRole.directivo,
                            onTap: () => setState(() => _selectedRole = UserRole.directivo),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _RoleCard(
                            role: UserRole.padreDeFamilia,
                            isSelected: _selectedRole == UserRole.padreDeFamilia,
                            onTap: () => setState(() => _selectedRole = UserRole.padreDeFamilia),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 130,
        decoration: BoxDecoration(
          color: const Color(0xFFE0F7FA),
          borderRadius: BorderRadius.circular(18),
          border: isSelected
              ? Border.all(color: const Color(0xFF0038FF), width: 3.0)
              : Border.all(color: Colors.transparent, width: 3.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.12 : 0.05),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                role.assetPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    role.fallbackIcon,
                    size: 48,
                    color: isSelected ? const Color(0xFF0038FF) : Colors.black87,
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            Text(
              role.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF0038FF) : const Color(0xFF1B365D),
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
