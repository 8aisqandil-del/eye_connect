import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'views/guest/home_dashboard.dart';
import 'views/volunteer/volunteer_dashboard.dart';
import 'views/donor/donor_dashboard.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. Show loading spinner while Firebase checks token status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF0F172A)),
            ),
          );
        }

        final User? user = snapshot.data;

        // 2. CASE 1: No active session -> Drop them on your clean guest dashboard
        if (user == null) {
          return const HomeDashboard();
        }

        // 3. CASE 2: Verified active session -> Route based on email tags
        if (user.email == 'admin@gmail.com') {
          // You can point this to your admin workspace panel later
          return const Scaffold(body: Center(child: Text("Admin Portal Active")));
        } else if (user.email != null && user.email!.contains('donor')) {
          return const DonorDashboard(); // Opens your new JOD tracking dashboard
        } else {
          return const VolunteerDashboard(); // Opens your new 8aisqandil Field Station
        }
      },
    );
  }
}