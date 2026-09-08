import 'package:flutter/material.dart';
import '../routes.dart';

/// Pantalla de bienvenida / portada de inicio.
/// Primer punto de contacto del usuario con la app.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo degradado (imagen exportada del diseño).
          Image.asset(
            'assets/images/welcome_degradado_fondo.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
                ),
              ),
            ),
          ),

          // 4 flores pequeñas, una por esquina, usando el mismo asset
          // reflejado/rotado en vez de una sola imagen estirada a
          // pantalla completa.
          const _CornerFlower(alignment: Alignment.topLeft),
          const _CornerFlower(alignment: Alignment.topRight, flipX: true),
          const _CornerFlower(alignment: Alignment.bottomLeft, flipY: true),
          const _CornerFlower(
            alignment: Alignment.bottomRight,
            flipX: true,
            flipY: true,
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / escudo del colegio, sin fondo blanco: solo el
                  // logo (asume que el PNG ya tiene fondo transparente).
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Image.asset(
                      'assets/images/logo_colegio.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.shield_outlined,
                          size: 56,
                          color: Color(0xFF1565C0),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Alerta Educativa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    'Anticipamos el riesgo,\nprotegemos el futuro',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Ilustración de la persona.
                  SizedBox(
                    height: 160,
                    child: Image.asset(
                      'assets/images/welcome_persona.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Una herramienta para fortalecer\nel acompañamiento educativo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Botón de acceso -> navega a la selección de rol / login
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'COMENZAR',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'v1.0.0',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Flor decorativa reutilizada en cada esquina de la portada,
/// reflejada según la esquina para que "abrace" el borde correspondiente.
class _CornerFlower extends StatelessWidget {
  final Alignment alignment;
  final bool flipX;
  final bool flipY;

  const _CornerFlower({
    required this.alignment,
    this.flipX = false,
    this.flipY = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Transform.scale(
        scaleX: flipX ? 1 : -1,
        scaleY: flipY ? -1 : 1,
        child: SizedBox(
          width: 90,
          height: 90,
          child: Image.asset(
            'assets/images/welcome_flores_laterales.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
            const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}