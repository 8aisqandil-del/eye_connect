import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    // Format the creation timestamp cleanly (fallback if null)
    String joinDate = "Recent Member";
    if (user?.metadata.creationTime != null) {
      joinDate = "${user!.metadata.creationTime!.day}/${user.metadata.creationTime!.month}/${user.metadata.creationTime!.year}";
    }

    return Drawer(
      backgroundColor: const Color(0xFFF8FAFC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Premium Profile Header Card Block
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.teal.withOpacity(0.15),
                  child: const Icon(Icons.person_rounded, size: 40, color: Colors.teal),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.email?.split('@')[0].toUpperCase() ?? "ACTIVE ACCOUNT",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? "No Email Associated",
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
          ),

          // Metadata Info Section
          Padding(
            padding: const EdgeInsets.all(24.0),
            key: const Key('account_details_sec'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Account Metadata",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
                ),
                const SizedBox(height: 12),
                
                _buildInfoTile(Icons.fingerprint_rounded, "UID Parameter", user?.uid ?? "N/A"),
                const SizedBox(height: 12),
                _buildInfoTile(Icons.calendar_month_rounded, "Registration Date", joinDate),
                const SizedBox(height: 12),
                _buildInfoTile(Icons.security_rounded, "Verified Node", user?.emailVerified == true ? "Secure Status" : "Pending Verification"),
              ],
            ),
          ),
          
          const Spacer(),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          
          // Sign Out Action Block inside the drawer footer segment
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(vertical: 12),
                // 🚀 FIXED: Wrapped the circular radius within a correct RoundedRectangleBorder shape class
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context); // Close Drawer
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 16),
              label: const Text("Terminate Session", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF475569)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF10172A)), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}