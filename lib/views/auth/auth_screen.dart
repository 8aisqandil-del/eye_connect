import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../guest/home_dashboard.dart'; // 🚀 FIXED IMPORT: Points directly to your guest homepage

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUp = true; 
  String _selectedRole = 'volunteer'; 
  
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final auth = FirebaseAuth.instance;

    try {
      if (_isSignUp) {
        if (_passwordController.text != _confirmPasswordController.text) {
          throw FirebaseAuthException(code: 'match-error', message: 'Passwords do not match.');
        }
        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication Failed'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Google Authentication Failed'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _isSignUp ? Icons.person_add_alt_1_rounded : Icons.login_rounded, 
                        color: Colors.white, 
                        size: 24
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    _isSignUp ? "Create your account" : "Welcome back",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 28, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isSignUp ? "Choose your operational path below" : "Sign in to manage your shift",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  if (_isSignUp) ...[
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildRoleSelectionButton(
                              label: "Volunteer",
                              icon: Icons.gavel_rounded,
                              isActive: _selectedRole == 'volunteer',
                              onTap: () => setState(() => _selectedRole = 'volunteer'),
                            ),
                          ),
                          Expanded(
                            child: _buildRoleSelectionButton(
                              label: "Donor",
                              icon: Icons.volunteer_activism_rounded,
                              isActive: _selectedRole == 'donor',
                              onTap: () => setState(() => _selectedRole = 'donor'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: _isLoading ? null : _handleGoogleSignIn,
                    icon: Image.network(
                      'https://developers.google.com/static/identity/images/g-logo.png',
                      height: 18,
                      width: 18,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata_rounded, color: Colors.blue, size: 22),
                    ),
                    label: Expanded( 
                      child: Text(
                        _isSignUp ? "Continue with Google" : "Sign in with Google",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF10172A), fontWeight: FontWeight.w600, fontSize: 14),
                        overflow: TextOverflow.ellipsis, 
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      const Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text("OR", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text("Email", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF10172A))),
                  const SizedBox(height: 8),
                  _buildStyledTextField(
                    controller: _emailController,
                    hint: _isSignUp && _selectedRole == 'donor' ? "must-contain-donor@mail.com" : "you@example.com",
                    icon: Icons.mail_outline_rounded,
                    obscure: false,
                    validator: (val) => val == null || !val.contains('@') ? 'Enter a valid email' : null,
                  ),
                  const SizedBox(height: 20),

                  const Text("Password", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF10172A))),
                  const SizedBox(height: 8),
                  _buildStyledTextField(
                    controller: _passwordController,
                    hint: "••••••••",
                    icon: Icons.lock_outline_rounded,
                    obscure: true,
                    validator: (val) => val == null || val.length < 6 ? 'Password must be 6+ chars' : null,
                  ),
                  const SizedBox(height: 20),

                  if (_isSignUp) ...[
                    const Text("Confirm Password", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF10172A))),
                    const SizedBox(height: 8),
                    _buildStyledTextField(
                      controller: _confirmPasswordController,
                      hint: "••••••••",
                      icon: Icons.lock_outline_rounded,
                      obscure: true,
                      validator: (val) => _isSignUp && val != _passwordController.text ? 'Passwords do not match' : null,
                    ),
                    const SizedBox(height: 24),
                  ],

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    onPressed: _isLoading ? null : _handleSubmit,
                    child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(_isSignUp ? "Create account" : "Sign In", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  const SizedBox(height: 20),

                  // 🚀 FIXED BYPASS ACTION BUTTON
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: const Color(0xFF0F172A),
                      elevation: 0,
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.person_outline_rounded, color: Color(0xFF64748B), size: 18),
                    label: const Text("Return to Home Dashboard", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    onPressed: _isLoading ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeDashboard()), // 🚀 FIXED: Instantly links to your newly structured guest dashboard class
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_isSignUp ? "Already have an account? " : "New to the campaign? ", style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                      GestureDetector(
                        onTap: () => setState(() => _isSignUp = !_isSignUp),
                        child: Text(
                          _isSignUp ? "Sign In" : "Register Now",
                          style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelectionButton({required String label, required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))] : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isActive ? const Color(0xFF0F172A) : const Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? const Color(0xFF0F172A) : const Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledTextField({required TextEditingController controller, required String hint, required IconData icon, required bool obscure, required String? Function(String?) validator}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      cursorColor: const Color(0xFF0F172A),
      style: const TextStyle(fontSize: 14, color: Color(0xFF10172A)),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 18),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.redAccent)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
      ),
    );
  }
}