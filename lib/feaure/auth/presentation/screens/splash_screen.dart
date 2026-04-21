import 'package:flutter/material.dart';
import 'package:lebroid_crm/feaure/auth/presentation/screens/login_screen.dart';
import 'package:lebroid_crm/resources/ImageAssets/ImageAssets.dart';
import 'dart:async';
// import '../../../../feaure/bottom_navigation_bar/presentation/widgets/custom_nav_widget.dart';
import '../../../Employee/bottom_navigation_bar/presentation/widgets/custom_nav_widget.dart';
import '../../../../notification/notication.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    /// ✅ INIT NOTIFICATION SERVICES (must be after frame so context is available)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationServices().init(context);
    });

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with animation
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                  ImageAssets.lebroidImg,
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return  Image.asset(
                        ImageAssets.lebroidImg
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // App Name
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                'Lebroid CRM',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'Office Management App',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Loading indicator
            SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withValues(alpha: 0.7),
                ),
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
