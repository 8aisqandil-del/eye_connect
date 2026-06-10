import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart'; 
import 'package:provider/provider.dart';
import 'view_models/auth_viewmodel.dart';
import 'auth_gate.dart';
import 'views/guest/guest_home.dart';



void main() async {
  // 1. Ensure the Flutter rendering framework is awake before initialization
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Fire up the Firebase engine using the manual file you just filled out
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: const EyeConnectApp(),
    )
    );}

class EyeConnectApp extends StatelessWidget {
  const EyeConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EyeConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home:  const GuestHome(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
   ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Latest Updates",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF10172A)),
        ),
        const SizedBox(height: 4),
        const Text(
          "See how eye health campaigns are developing in Jordan",
          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
        ),
        const SizedBox(height: 16),
        
        // Mock Campaign Card 1
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campaign Header Visual Block
              Container(
                height: 160,
                decoration: const BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16), 
                    topRight: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    colors: [Colors.teal, Color(0xFF004D40)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  // FIXED: Changed white55 to white60
                  child: Icon(Icons.remove_red_eye_rounded, size: 50, color: Colors.white60),
                ),
              ),
              // FIXED: Replaced 'children: []' with a single 'child: Column(children: [])'
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Urgent Campaign",
                      style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Amman Annual Eye Screening Drive",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF10172A)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Join our medical team this Friday in downtown Amman for free screenings and donor matching registration pipelines.",
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  ),
    const Center(child: Text('👁️ Donation Pledge Form', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal))),
    const Center(child: Text('📍 Clinic Finder (Maps)', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal))),
    const Center(child: Text('👤 User Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EyeConnect', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        centerTitle: true,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'),
          BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism), label: 'Pledge'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Clinics'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}