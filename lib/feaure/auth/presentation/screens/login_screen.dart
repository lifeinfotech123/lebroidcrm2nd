import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:lebroid_crm/feaure/Admin/presentation/screen/admin_dashboard_screen.dart';
// import '../../../../feaure/bottom_navigation_bar/presentation/widgets/custom_nav_widget.dart';
import '../../../../resources/ImageAssets/ImageAssets.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../Admin/admin_dashboard/presentation/screen/admin_dashboard_screen.dart';
import '../../../Employee/bottom_navigation_bar/presentation/widgets/custom_nav_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logics/auth_bloc.dart';
import '../../logics/auth_event.dart';
import '../../logics/auth_state.dart';

import '../../../../notification/notication.dart';
import '../../../Admin/employees_management/screen/employee_dashboar_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); 
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final token = await NotificationServices().getDeviceToken();
      if (!mounted) return;
      context.read<AuthBloc>().add(
        AdminLoginEvent(_emailController.text, _passwordController.text,token),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {

          if (state is AuthAdminSuccess) {
            if (state.role.toLowerCase() == 'employee') {
              Get.offAll(() => const EmployeeDashboarScreen());
            } else {
              Get.offAll(() => const AdminDashboardScreen());
            }
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }

        },

        builder: (context, state) {
          return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 50),

              // Logo with shadowhttp://localhost:3000/school/register
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(ImageAssets.lebroidlogo, height: 70),
              ),

              const SizedBox(height: 30),

              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Login to your account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 35),

              /// Login Card
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 0,
                      offset: const Offset(0, 15),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 60,
                      spreadRadius: 0,
                      offset: const Offset(0, 30),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      NewCustomTextField(
                        hint: 'Username',
                        controller: _emailController,
                        icon: Icons.person_outline,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      NewCustomTextField(
                        hint: 'Password',
                        controller: _passwordController,
                        icon: Icons.lock_outline,
                        obscureText: true,
                        validator: (value) {

                          if (value == null || value.isEmpty) {

                            return 'Password is required';

                          }

                          if (value.length < 6) {
                            return 'Minimum 6 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2196F3), Color(0xFF1565C0)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF1565C0,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: state is AuthLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        )
        );
        },
      ),
    );
  }
}
