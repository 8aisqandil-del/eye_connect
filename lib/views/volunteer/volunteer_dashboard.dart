import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screening_form.dart'; // 🚀 FIXED: Points to your exact file name now

class VolunteerDashboard extends StatefulWidget {
  const VolunteerDashboard({super.key});

  @override
  State<VolunteerDashboard> createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  bool _showScreeningForm = false;

  @override
  Widget build(BuildContext context) {
    if (_showScreeningForm) {
      return PatientScreeningForm(
        onBack: () => setState(() => _showScreeningForm = false),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🚀 HEADER PANEL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 16),
                  Text("THURSDAY, JUNE 11", style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  SizedBox(height: 6),
                  Text("Hey, 8aisqandil! 👋", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)), // 🚀 FIXED: FontWeight.w900
                  SizedBox(height: 6),
                  Text("Welcome back to your Field Station. Your screening toolkit and camp\nassignments are ready below.", style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🚨 URGENT NOTIFICATION BANNER
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFEE2E2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Zaatari Mobile Unit Deployment Update", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 13)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(4)),
                                    child: const Text("urgent", style: TextStyle(color: Color(0xFFEF4444), fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text("Mobile screening unit logistics confirmed for March 1st deployment. All assigned volunteers must complete safety briefing by Feb 25th.", style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                            ],
                          ),
                        ),
                        const Text("2/3", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 📊 STATS METRIC GRID
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard("PATIENTS SCREENED", "8", "Total screenings recorded", Icons.people_outline_rounded, const Color(0xFF1E3A8A), true)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMetricCard("REFERRALS FLAGGED", "4", "Requiring specialist review", Icons.warning_amber_rounded, Colors.white, false)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMetricCard("ACTIVE SITES", "3", "Currently operational", Icons.pin_drop_outlined, Colors.white, false)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMetricCard("TODAY'S TARGET", "30", "Daily screening goal", Icons.remove_red_eye_outlined, Colors.white, false)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 🧰 CLINICAL TOOLKIT HEADER
                  Row(
                    children: const [
                      Icon(Icons.assignment_outlined, color: Color(0xFF0F172A), size: 20),
                      SizedBox(width: 8),
                      Text("Clinical Toolkit", style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ⚡ ACTIONS GRID ROW
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showScreeningForm = true),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(Icons.note_add_rounded, color: Colors.tealAccent, size: 20),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text("New Patient Screening Form", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                      SizedBox(height: 4),
                                      Text("Record visual acuity tests, diagnostic outcomes, and referral flags for new patients.", style: TextStyle(color: Colors.white60, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded, color: Colors.white30),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.map_outlined, color: Color(0xFF64748B), size: 20),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text("Assigned Camp Locations", style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 14)),
                                    SizedBox(height: 4),
                                    Text("View live deployment status, capacities, and volunteer assignments for all screening sites.", style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded, color: Color(0xFFCBD5E1)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // BOTTOM SPLIT DATA SECTION
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Assigned Camp Locations", style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 16),
                            _buildCampLocationCard("Karak Rural Eye Camp", "Southern Karak Village Center", "Deploying", "8/40", 0.2, "2 volunteers", "Karak", Colors.orange),
                            const SizedBox(height: 12),
                            _buildCampLocationCard("Aqaba Coastal Screening", "Aqaba Port Area Clinic", "Completed", "50/50", 1.0, "4 volunteers", "Aqaba", Colors.purple),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Recent Screenings History", style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 16),
                            _buildHistoryItem("Omar Khalil", "12y • Male • Irbid Community Health Center", "L: 20/30   R: 20/30", "Possible myopia, glasses recommended", "Mild", Colors.blue),
                            const SizedBox(height: 12),
                            _buildHistoryItem("Nour Al-Din", "8y • Female • Irbid Community Health Center", "L: 20/20   R: 20/20", "Vision checked out completely normal", "Normal", Colors.green),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String val, String desc, IconData icon, Color bg, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: isDark ? null : Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: isDark ? Colors.white60 : const Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              Icon(icon, color: isDark ? Colors.tealAccent : const Color(0xFF94A3B8), size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(val, style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 26, fontWeight: FontWeight.w900)), // 🚀 FIXED: FontWeight.w900
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(color: isDark ? Colors.white38 : const Color(0xFF94A3B8), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildCampLocationCard(String title, String subtitle, String tag, String capText, double progress, String vCount, String locTag, Color tagColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: tagColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(tag, style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Capacity", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
              Text(capText, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(value: progress, backgroundColor: const Color(0xFFF1F5F9), color: const Color(0xFF1E3A8A), minHeight: 4, borderRadius: BorderRadius.circular(2)),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.people_outline_rounded, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(vCount, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              const SizedBox(width: 16),
              const Icon(Icons.pin_drop_outlined, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(locTag, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String name, String meta, String lines, String diagnosis, String tag, Color tagColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Color(0xFFF8FAFC), shape: BoxShape.circle),
            child: const Icon(Icons.remove_red_eye_outlined, color: Color(0xFF64748B), size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 14)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: tagColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text(tag, style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 2),
                Text(meta, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                const SizedBox(height: 10),
                Text(lines, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                const SizedBox(height: 4),
                Text(diagnosis, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}