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

          // 4 flores, cada una es su propio asset (ya vienen correctamente
          // orientadas por esquina, sin necesidad de espejarlas).
          // Ajustables a mano:
          // - size: tamaño en pantalla (ancho y alto del asset).
          // - rotationDegrees: gira la imagen si hiciera falta.
          // - offsetX / offsetY: la mueve desde la esquina; negativo en X
          //   la mueve hacia la izquierda, negativo en Y hacia arriba
          //   (usa esto para cerrar cualquier espacio en blanco).
          const _CornerFlower(
            assetPath: 'assets/images/welcome_flores_laterales_izquierda.png',
            corner: _Corner.topLeft,
            size: 200,
            rotationDegrees: 0,
            offsetX: -24,
            offsetY: 0,
          ),
          const _CornerFlower(
            assetPath: 'assets/images/welcome_flores_laterales_derecha.png',
            corner: _Corner.topRight,
            size: 200,
            rotationDegrees: 0,
            offsetX: -24,
            offsetY: 0,
          ),
          const _CornerFlower(
            // OJO: el nombre del archivo trae ese typo ("ezquierda"),
            // se respeta tal cual porque el asset path debe ser exacto.
            assetPath:
            'assets/images/welcome_flores_laterales_abajo_ezquierda.png',
            corner: _Corner.bottomLeft,
            size: 200,
            rotationDegrees: 0,
            offsetX: -8,
            offsetY: 0,
          ),
          const _CornerFlower(
            assetPath:
            'assets/images/welcome_flores_laterales_abajo_derecha.png',
            corner: _Corner.bottomRight,
            size: 200,
            rotationDegrees: 0,
            offsetX: -8,
            offsetY: 0,
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / escudo del colegio, sin fondo blanco: solo el
                  // logo (asume que el PNG ya tiene fondo transparente).
                  SizedBox(
                    width: 200,
                    height: 180,
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
                    height: 200,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 74.0),
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

enum _Corner { topLeft, topRight, bottomLeft, bottomRight }

/// [WelcomeScreen.build].
class _CornerFlower extends StatelessWidget {
  final String assetPath;
  final _Corner corner;
  final double size;
  final double rotationDegrees;
  final double offsetX;
  final double offsetY;

  const _CornerFlower({
    required this.assetPath,
    required this.corner,
    required this.size,
    this.rotationDegrees = 0,
    this.offsetX = 0,
    this.offsetY = 0,
  });

  bool get _isTop => corner == _Corner.topLeft || corner == _Corner.topRight;
  bool get _isLeft =>
      corner == _Corner.topLeft || corner == _Corner.bottomLeft;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _isTop ? offsetY : null,
      bottom: _isTop ? null : offsetY,
      left: _isLeft ? offsetX : null,
      right: _isLeft ? null : offsetX,
      child: Transform.rotate(
        angle: rotationDegrees * 3.1415926535 / 180,
        child: SizedBox(
          width: size,
          height: size,
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
            const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}