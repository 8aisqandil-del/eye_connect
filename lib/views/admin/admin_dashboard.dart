import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screening_pipeline.dart'; // 🚀 Import the pipeline screen

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _handleSignOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A), // Premium sleek dark slate header
        elevation: 0,
        title: const Text(
          "Admin Control Panel",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () => _handleSignOut(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "System Overview Metrics",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF10172A)),
            ),
            const SizedBox(height: 12),

            // Real-time collection aggregate stream
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, userSnapshot) {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('screenings').snapshots(),
                  builder: (context, screeningSnapshot) {
                    
                    // Default fallback strings if loading
                    String totalUsers = "...";
                    String activeDrives = "...";

                    if (userSnapshot.hasData) {
                      totalUsers = userSnapshot.data!.docs.length.toString();
                    }
                    if (screeningSnapshot.hasData) {
                      activeDrives = screeningSnapshot.data!.docs.length.toString();
                    }

                    return Row(
                      children: [
                        Expanded(child: _buildStatCard("Total System Users", totalUsers, Colors.indigo)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard("Logged Screenings", activeDrives, Colors.teal)),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            const Text(
              "Management Gateways",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF10172A)),
            ),
            const SizedBox(height: 12),

            // Admin Control Actions List
            _buildManagementTile(
              Icons.people_alt_rounded, 
              "Manage Account Registrations", 
              "Approve or update roles"
            ),
            
            const SizedBox(height: 12),
            
            // 🚀 DEVELOPER FIX: Wrapped the pipeline tile inside a clickable InkWell navigation loop
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScreeningPipeline()),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: _buildManagementTile(
                Icons.remove_red_eye_rounded, 
                "Screening Campaign Pipeline", 
                "Monitor system diagnostics data"
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          const SizedBox(height: 8),
          Text(count, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildManagementTile(IconData icon, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFF1F5F9),
          child: Icon(icon, color: const Color(0xFF0F172A)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      ),
    );
  }
}