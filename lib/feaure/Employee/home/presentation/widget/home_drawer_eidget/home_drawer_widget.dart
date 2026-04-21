import 'package:flutter/material.dart';


import '../../../../../auth/presentation/screens/admin_login_screen.dart';
import '../../../../../auth/presentation/screens/user_login_screen.dart';
import '../../screens/complain_list_screen.dart';
import '../../screens/donation_list_screen.dart';
import '../../screens/legal_document_list_screen.dart';
class HomeDrawerWidget extends StatelessWidget {
  const HomeDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          // HEADER
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  "Manav Adhikar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),

          // DONATION LIST
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text("Donation List"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DonationListScreen()),
              );
            },
          ),

          // LEGAL DOCS
          ListTile(
            leading: Icon(Icons.article),
            title: Text("Legal Documents"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LegalDocumentScreen()),
              );
            },
          ),

          // COMPLAINT LIST
          ListTile(
            leading: Icon(Icons.report_problem),
            title: Text("Complaint List"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ComplainsScreen()),
              );
            },
          ),

          Divider(),

          // 🔥 ADMIN LOGIN
          ListTile(
            leading: Icon(Icons.admin_panel_settings, color: Colors.red),
            title: Text("Admin Login"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AdminLoginScreen()),
              );
            },
          ),

          // 👤 USER LOGIN
          ListTile(
            leading: Icon(Icons.login, color: Colors.green),
            title: Text("User Login"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserLoginScreen()),
              );
            },
          ),

        ],
      ),
    );
  }
}
