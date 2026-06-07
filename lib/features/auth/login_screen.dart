import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool rememberMe = false;
  String? errorMessage;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on AuthException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Something went wrong. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _RoamlyBackground()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 118,
                          height: 118,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFE8FF81),
                                Color(0xFF49B832),
                                Color(0xFF053D1B),
                              ],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x8045E23D),
                                blurRadius: 34,
                                offset: Offset(0, 16),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              'assets/logos/Icon.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Welcome Back!',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Continue your route through Roamly.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFD7F5C7),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xE60A5C3C),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0x6649D96C)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x7300130B),
                              blurRadius: 28,
                              offset: Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel(text: 'Email'),
                            const SizedBox(height: 8),
                            _LoginField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'Enter your email',
                              icon: Icons.mail_outline,
                            ),
                            const SizedBox(height: 16),
                            _FieldLabel(text: 'Password'),
                            const SizedBox(height: 8),
                            _LoginField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              hintText: 'Enter your password',
                              icon: Icons.lock_outline,
                              trailing: IconButton(
                                tooltip: obscurePassword
                                    ? 'Show password'
                                    : 'Hide password',
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF0D7D62),
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: Checkbox(
                                    value: rememberMe,
                                    activeColor: const Color(0xFFB8F45F),
                                    checkColor: const Color(0xFF06351E),
                                    side: const BorderSide(
                                      color: Color(0xFFCFF6C3),
                                      width: 1.3,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        rememberMe = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(
                                    color: Color(0xFFE7F8DA),
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFFE7F8DA),
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 32),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            if (errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFECEC),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  errorMessage!,
                                  style: const TextStyle(
                                    color: Color(0xFFAD1F1F),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFEFFF88),
                                      Color(0xFF55D37A),
                                      Color(0xFF118B77),
                                    ],
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x705BEA75),
                                      blurRadius: 16,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    disabledBackgroundColor: Colors.white
                                        .withValues(alpha: 0.16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: Text(
                                    isLoading ? 'Signing in...' : 'Sign in',
                                    style: const TextStyle(
                                      color: Color(0xFF05351E),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              'OR LOGIN WITH',
                              style: TextStyle(
                                color: Color(0xFFD7F5C7),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                _SocialButton(icon: Icons.g_mobiledata),
                                SizedBox(width: 14),
                                _SocialButton(icon: Icons.facebook),
                                SizedBox(width: 14),
                                _SocialButton(icon: Icons.explore_outlined),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  'Do not have an account? ',
                                  style: TextStyle(
                                    color: Color(0xFFE7F8DA),
                                    fontSize: 12,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFFEFFF88),
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 28),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Register Now',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoamlyBackground extends StatelessWidget {
  const _RoamlyBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RouteBackgroundPainter(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF032111),
              Color(0xFF064424),
              Color(0xFF0C7F54),
              Color(0xFF55B52C),
            ],
            stops: [0, 0.42, 0.76, 1],
          ),
        ),
      ),
    );
  }
}

class _RouteBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final mistPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              Colors.white.withValues(alpha: 0.24),
              Colors.white.withValues(alpha: 0.06),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.84, size.height * 0.18),
              radius: size.width * 0.48,
            ),
          );

    canvas.drawCircle(
      Offset(size.width * 0.84, size.height * 0.18),
      size.width * 0.48,
      mistPaint,
    );

    final routePaint = Paint()
      ..color = const Color(0xFFEFFF88).withValues(alpha: 0.13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    for (var index = 0; index < 5; index++) {
      final yOffset = size.height * (0.12 + index * 0.16);
      final path = Path()
        ..moveTo(-30, yOffset)
        ..cubicTo(
          size.width * 0.25,
          yOffset - 50,
          size.width * 0.34,
          yOffset + 78,
          size.width * 0.58,
          yOffset + 18,
        )
        ..cubicTo(
          size.width * 0.78,
          yOffset - 28,
          size.width * 0.84,
          yOffset + 86,
          size.width + 28,
          yOffset + 20,
        );
      canvas.drawPath(path, routePaint);
    }

    final glowPath = Path()
      ..moveTo(size.width * 0.24, -20)
      ..cubicTo(
        size.width * 0.92,
        size.height * 0.06,
        size.width * 0.30,
        size.height * 0.32,
        size.width * 0.70,
        size.height * 0.47,
      )
      ..cubicTo(
        size.width * 1.05,
        size.height * 0.61,
        size.width * 0.18,
        size.height * 0.72,
        size.width * 0.84,
        size.height + 40,
      );

    canvas.drawPath(
      glowPath,
      Paint()
        ..color = const Color(0xFFEFFF88).withValues(alpha: 0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 52
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      glowPath,
      Paint()
        ..color = const Color(0xFFF7FFAF).withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round,
    );

    final cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.13)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    final cloudCenters = [
      Offset(size.width * 0.78, size.height * 0.72),
      Offset(size.width * 0.90, size.height * 0.76),
      Offset(size.width * 0.70, size.height * 0.80),
      Offset(size.width * 0.83, size.height * 0.84),
    ];

    for (final center in cloudCenters) {
      canvas.drawCircle(center, size.width * 0.16, cloudPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFE7F8DA),
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.trailing,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: const Color(0xFF0D7D62),
      style: const TextStyle(
        color: Color(0xFF06351E),
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0x99105F48),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: const Color(0xFFE8FFF1),
        prefixIcon: Icon(icon, color: const Color(0xFF0D7D62), size: 20),
        suffixIcon: trailing,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFEFFF88), width: 2),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFE8FFF1),
          borderRadius: BorderRadius.circular(19),
          boxShadow: const [
            BoxShadow(
              color: Color(0x5545E23D),
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF0D7D62), size: 25),
      ),
    );
  }
}
