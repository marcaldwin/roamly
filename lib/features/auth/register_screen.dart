import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final displayNameController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> register() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {
          'username': usernameController.text.trim(),
          'display_name': displayNameController.text.trim(),
        },
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
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
    usernameController.dispose();
    displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _RegisterBackground()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                        color: const Color(0xFFE7F8DA),
                        tooltip: 'Back',
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          width: 104,
                          height: 104,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFEFFF88),
                                Color(0xFF50C94D),
                                Color(0xFF05421F),
                              ],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x8045E23D),
                                blurRadius: 32,
                                offset: Offset(0, 16),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.asset(
                              'assets/logos/Icon.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      Text(
                        'Start Your Journey',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your Roamly account and unlock your map.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFD7F5C7),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 24),
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
                            const _RegisterFieldLabel(text: 'Display Name'),
                            const SizedBox(height: 8),
                            _RegisterField(
                              controller: displayNameController,
                              hintText: 'Enter your display name',
                              icon: Icons.badge_outlined,
                            ),
                            const SizedBox(height: 14),
                            const _RegisterFieldLabel(text: 'Username'),
                            const SizedBox(height: 8),
                            _RegisterField(
                              controller: usernameController,
                              hintText: 'Choose a username',
                              icon: Icons.alternate_email,
                            ),
                            const SizedBox(height: 14),
                            const _RegisterFieldLabel(text: 'Email'),
                            const SizedBox(height: 8),
                            _RegisterField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'Enter your email',
                              icon: Icons.mail_outline,
                            ),
                            const SizedBox(height: 14),
                            const _RegisterFieldLabel(text: 'Password'),
                            const SizedBox(height: 8),
                            _RegisterField(
                              controller: passwordController,
                              obscureText: true,
                              hintText: 'Create a password',
                              icon: Icons.lock_outline,
                            ),
                            if (errorMessage != null) ...[
                              const SizedBox(height: 14),
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
                            const SizedBox(height: 20),
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
                                  onPressed: isLoading ? null : register,
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
                                    isLoading
                                        ? 'Creating account...'
                                        : 'Create account',
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
                      const SizedBox(height: 18),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: Color(0xFFE7F8DA),
                                fontSize: 12,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFFEFFF88),
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 28),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
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

class _RegisterBackground extends StatelessWidget {
  const _RegisterBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RegisterBackgroundPainter(),
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

class _RegisterBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final mistPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              Colors.white.withValues(alpha: 0.22),
              Colors.white.withValues(alpha: 0.06),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.86, size.height * 0.16),
              radius: size.width * 0.5,
            ),
          );

    canvas.drawCircle(
      Offset(size.width * 0.86, size.height * 0.16),
      size.width * 0.5,
      mistPaint,
    );

    final mapLinePaint = Paint()
      ..color = const Color(0xFFEFFF88).withValues(alpha: 0.13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var index = 0; index < 5; index++) {
      final yOffset = size.height * (0.10 + index * 0.17);
      final path = Path()
        ..moveTo(-28, yOffset)
        ..cubicTo(
          size.width * 0.20,
          yOffset + 62,
          size.width * 0.38,
          yOffset - 44,
          size.width * 0.60,
          yOffset + 10,
        )
        ..cubicTo(
          size.width * 0.84,
          yOffset + 68,
          size.width * 0.74,
          yOffset - 34,
          size.width + 32,
          yOffset + 24,
        );
      canvas.drawPath(path, mapLinePaint);
    }

    final routePath = Path()
      ..moveTo(size.width * 0.68, -30)
      ..cubicTo(
        size.width * 0.12,
        size.height * 0.13,
        size.width * 0.94,
        size.height * 0.30,
        size.width * 0.38,
        size.height * 0.48,
      )
      ..cubicTo(
        -20,
        size.height * 0.62,
        size.width * 0.82,
        size.height * 0.73,
        size.width * 0.38,
        size.height + 36,
      );

    canvas.drawPath(
      routePath,
      Paint()
        ..color = const Color(0xFFEFFF88).withValues(alpha: 0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 52
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      routePath,
      Paint()
        ..color = const Color(0xFFF7FFAF).withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round,
    );

    final cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.13)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    for (final center in [
      Offset(size.width * 0.78, size.height * 0.74),
      Offset(size.width * 0.92, size.height * 0.78),
      Offset(size.width * 0.68, size.height * 0.82),
    ]) {
      canvas.drawCircle(center, size.width * 0.16, cloudPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RegisterFieldLabel extends StatelessWidget {
  const _RegisterFieldLabel({required this.text});

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

class _RegisterField extends StatelessWidget {
  const _RegisterField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;

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
