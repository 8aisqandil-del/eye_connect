import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screening_form.dart';
import 'volunteer_camps.dart'; 
import '../shared/profile_drawer.dart'; 

class VolunteerDashboard extends StatelessWidget {
  const VolunteerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    // Clean, robust parsing for your display name
    String rawName = user?.email?.split('@')[0] ?? "Volunteer";
    if (rawName.startsWith(RegExp(r'[0-9]'))) {
      rawName = rawName.replaceFirst(RegExp(r'[0-9]+'), ''); 
    }
    String stylizedName = rawName.isNotEmpty 
        ? rawName[0].toUpperCase() + rawName.substring(1) 
        : "Volunteer";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const ProfileDrawer(), 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
        title: const Text(
          "EyeConnect Operational Station",
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🌟 Top Gradient Branding Welcome Header block
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("WEDNESDAY, JUNE 10", style: TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  Text("Hey, $stylizedName! 👋", style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                  const SizedBox(height: 6),
                  const Text("Welcome back to your Field Station. Your screening toolkit and camp assignments are ready below.", style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ⚠️ System Maintenance Informational Ticker Banner Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text("System Maintenance Window", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF78350F))),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(20)),
                              child: const Text("low", style: TextStyle(fontSize: 10, color: Color(0xFFB45309), fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text("Scheduled maintenance on March 5th, 2:00-4:00 AM GMT+3. Brief service interruptions expected.", style: TextStyle(fontSize: 12, color: Color(0xFF92400E))),
                      ],
                    ),
                  ),
                  const Text("3/3", style: TextStyle(fontSize: 11, color: Color(0xFFB45309), fontWeight: FontWeight.bold))
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 📊 Row Metric Scorecard Grid View blocks
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard("PATIENTS SCREENED", "8", "Total screenings recorded", const Color(0xFF1E1B4B), Colors.white, Icons.people_alt_rounded, true),
                  const SizedBox(width: 14),
                  _buildStatCard("REFERRALS FLAGGED", "4", "Requiring specialist review", Colors.white, const Color(0xFF10172A), Icons.warning_amber_rounded, false),
                  const SizedBox(width: 14),
                  _buildStatCard("ACTIVE SITES", "3", "Currently operational", Colors.white, const Color(0xFF10172A), Icons.pin_drop_outlined, false),
                  const SizedBox(width: 14),
                  _buildStatCard("TODAY'S TARGET", "30", "Daily screening goal", Colors.white, const Color(0xFF10172A), Icons.remove_red_eye_outlined, false),
                ],
              ),
            ),
            const SizedBox(height: 32),

            const Row(
              children: [
                Icon(Icons.assignment_outlined, size: 18, color: Color(0xFF0F172A)),
                SizedBox(width: 8),
                Text("Clinical Toolkit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              ],
            ),
            const SizedBox(height: 16),

            // Navigation Route Targets
            _buildToolkitTile(
              context,
              icon: Icons.add_moderator_rounded,
              title: "New Patient Screening Form",
              desc: "Log diagnostic metrics and visual acuity fields securely.",
              target: const ScreeningForm(),
            ),
            const SizedBox(height: 12),
            _buildToolkitTile(
              context,
              icon: Icons.map_outlined,
              title: "Assigned Camp Locations",
              desc: "Check active camp logistics, deployment schedules, and maps.",
              target: const VolunteerCamps(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String val, String desc, Color bg, Color textCol, IconData icon, bool isDark) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.tealAccent : const Color(0xFF64748B))),
              Icon(icon, size: 16, color: isDark ? Colors.tealAccent : const Color(0xFF64748B)),
            ],
          ),
          const SizedBox(height: 12),
          Text(val, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textCol)),
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : const Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildToolkitTile(BuildContext context, {required IconData icon, required String title, required String desc, required Widget target}) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: const Color(0xFFF1F5F9), child: Icon(icon, color: const Color(0xFF1E1B4B))),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}