import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonorDashboard extends StatelessWidget {
  const DonorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🚀 DONOR GRADIENT HERO PANEL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E1B4B), Color(0xFF1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 16),
                  Text("DONOR IMPACT DASHBOARD", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  SizedBox(height: 6),
                  Text("Welcome, 8aisqandil! 💝", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5)), // 🚀 FIXED: FontWeight.w900
                  SizedBox(height: 6),
                  Text("Track your contributions and see the real impact of your generosity across\nour eye care campaigns.", style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔔 NOTICE ALERT BANNER
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFEF3C7)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.notifications_none_rounded, color: Colors.amber, size: 18),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Q1 Donation Report Available  •  The Q1 2025 financial transparency report is now available for review in the donor dashboard.",
                            style: TextStyle(color: Color(0xFF451A03), fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text("2/2", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 📊 DONATION METRICS ROW
                  Row(
                    children: [
                      Expanded(child: _buildMetricBox("TOTAL PLEDGED", "46,500 JOD", "Across all campaigns", Icons.monetization_on_outlined, const Color(0xFF2E2C7A), true)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMetricBox("AMOUNT RECEIVED", "40,000 JOD", "Successfully processed", Icons.trending_up_rounded, Colors.white, false)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMetricBox("EQUIPMENT ITEMS", "2", "Donations tracked", Icons.widgets_outlined, Colors.white, false)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMetricBox("ACTIVE PLEDGES", "2", "Pending fulfillment", Icons.favorite_border_rounded, Colors.white, false)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 💸 DATA TABLES
                  _buildSectionHeader("Monetary Pledges", "4 records", Icons.payments_outlined),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Table(
                      columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(3), 2: FlexColumnWidth(2), 3: FlexColumnWidth(2), 4: FlexColumnWidth(2)},
                      children: [
                        _buildTableHeaderRow(["DONOR", "CAMPAIGN", "AMOUNT", "STATUS", "DATE"]),
                        _buildTableDataRow(["Dr. Sami Khoury", "Refugee Camp Initiative", "5,000 JOD", "pledged", "Jun 9, 2026"], Colors.purple),
                        _buildTableDataRow(["UAE Red Crescent", "Cross-Border Eye Care", "25,000 JOD", "received", "Jun 9, 2026"], Colors.green),
                        _buildTableDataRow(["Khalid Mansour", "Spring Eye Camp 2025", "1,500 JOD", "pledged", "Jun 9, 2026"], Colors.purple),
                        _buildTableDataRow(["Jordan Vision Foundation", "Spring Eye Camp 2025", "15,000 JOD", "received", "Jun 9, 2026"], Colors.green),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildSectionHeader("Equipment Sponsorship", "2 items", Icons.biotech_outlined),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Table(
                      columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(3), 2: FlexColumnWidth(1.5), 3: FlexColumnWidth(2), 4: FlexColumnWidth(2.5)},
                      children: [
                        _buildTableHeaderRow(["SPONSOR", "EQUIPMENT", "QTY", "STATUS", "CAMPAIGN"]),
                        _buildTableDataRow(["Al-Aman Medical Supplies", "Portable Autorefractor", "3", "deployed", "Equipment Drive Q1"], Colors.teal),
                        _buildTableDataRow(["OptoJordan Labs", "Slit Lamp Station", "1", "in-transit", "Karak Camp Expansion"], Colors.blue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Center(
                    child: TextButton.icon(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      icon: const Icon(Icons.logout_rounded, size: 16, color: Color(0xFF64748B)),
                      label: const Text("Exit Dashboard", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBox(String title, String val, String desc, IconData icon, Color bg, bool isDark) {
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
              Icon(icon, color: isDark ? Colors.tealAccent : const Color(0xFF94A3B8), size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(val, style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 22, fontWeight: FontWeight.w900)), // 🚀 FIXED: FontWeight.w900
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(color: isDark ? Colors.white38 : const Color(0xFF94A3B8), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String count, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF0F172A), size: 18),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
        Text(count, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
      ],
    );
  }

  TableRow _buildTableHeaderRow(List<String> cells) {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFF8FAFC), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      children: cells.map((cell) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(cell, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      )).toList(),
    );
  }

  TableRow _buildTableDataRow(List<String> cells, Color statusColor) {
    return TableRow(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))),
      children: cells.asMap().entries.map((entry) {
        int idx = entry.key;
        String text = entry.value;

        if (idx == 3) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(text, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        }

        bool isBoldVal = idx == 2;
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            text, 
            style: TextStyle(fontSize: 12, color: const Color(0xFF334155), fontWeight: isBoldVal ? FontWeight.bold : FontWeight.normal),
          ),
        );
      }).toList(),
    );
  }
}