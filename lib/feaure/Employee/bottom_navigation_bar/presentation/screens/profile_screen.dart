import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/auth/logics/auth_bloc.dart';
import 'package:lebroid_crm/feaure/auth/logics/auth_event.dart';
import 'package:lebroid_crm/feaure/auth/logics/auth_state.dart';
import 'package:lebroid_crm/feaure/auth/data/model/admin_login_model.dart';
import 'package:get/get.dart';
import 'package:lebroid_crm/feaure/auth/presentation/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(FetchProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutSuccess) {
          Get.offAll(() => const LoginScreen());
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff4f6fb),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthFailure) {
              return Center(child: Text("Error: ${state.error}"));
            } else if (state is AuthProfileSuccess) {
              final user = state.user;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _header(user),
                    const SizedBox(height: 20),
                    _infoCard(user),
                    const SizedBox(height: 20),

                    const SizedBox(height: 30),
                  ],
                ),
              );
            }
            return const Center(child: Text("No profile data."));
          },
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(AdminLoginUser user) {
    String initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : "";
    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff4e54c8), Color(0xff8f94fb)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.indigo,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.designation.isNotEmpty ? user.designation : "N/A",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutEvent());
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ================= PROFILE INFO =================
  Widget _infoCard(AdminLoginUser user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 6,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _InfoTile(
              icon: Icons.email,
              label: "Email",
              value: user.email.isNotEmpty ? user.email : "N/A",
            ),
            const Divider(height: 1),
            _InfoTile(
              icon: Icons.phone,
              label: "Phone",
              value: user.phone.isNotEmpty ? user.phone : "N/A",
            ),
            const Divider(height: 1),
            _InfoTile(
              icon: Icons.calendar_month,
              label: "Joining Date",
              value: user.joiningDate.isNotEmpty ? user.joiningDate : "N/A",
            ),
          ],
        ),
      ),
    );
  }


}

// ================= INFO TILE =================
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ================= DOCUMENT CARD =================
class _DocumentCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _DocumentCard({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // connect PDF generation here
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.indigo),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
