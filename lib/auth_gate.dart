import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'views/auth/auth_screen.dart'; 
import 'views/donor/donor_dashboard.dart';
import 'views/admin/admin_dashboard.dart';
import 'views/volunteer/volunteer_dashboard.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        
        // Tier 1: If no user is logged in, show the Auth UI Card card layout
        if (!authSnapshot.hasData) {
          return const AuthScreen(); 
        }

        User user = authSnapshot.data!;
        String email = user.email?.toLowerCase() ?? '';

        // 🚀 THE ULTIMATE RESET ROUTER:
        // Bypasses database rules completely for your demo viewport.
        // It routes instantly based on the email tag template you type in!
        if (email == 'admin@gmail.com' || email.endsWith('@eyeconnect.org')) {
          return const AdminDashboard();
        } else if (email.contains('donor')) {
          return const DonorDashboard();
        } else {
          // Every other standard account or Google click opens your Field Station!
          return const VolunteerDashboard();
        }
      },
    );
  }
}