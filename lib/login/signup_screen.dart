import 'package:flutter/material.dart';
import 'package:wealthwise/login/login_screen.dart';
import 'package:wealthwise/screens/homePage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static const _green = Color(0xFF4D6B43);
  static const _bg = Color(0xFFFBF8F2);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildHeaderRow(),
              const SizedBox(height: 28),
              _buildTextField(
                controller: _nameController,
                hint: "Full Name",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _emailController,
                hint: "Email Address",
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _passwordController,
                hint: "Password",
                icon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.shield, color: _green, size: 16),
                  const SizedBox(width: 6),
                  const Text(
                    "Password must be at least 8 characters",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _confirmPasswordController,
                hint: "Confirm Password",
                icon: Icons.lock_outline,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                ),
              ),
              const SizedBox(height: 28),
              _buildSignUpButton(),
              const SizedBox(height: 28),
              _buildLoginRow(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 10),
              const Text(
                "Start your journey to financial clarity and growth.",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _buildProfilePhotoPicker(),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          height: 1.2,
        ),
        children: [
          TextSpan(text: "Create Your\n"),
          TextSpan(text: "WealthWise\n", style: TextStyle(color: _green)),
          TextSpan(text: "Account"),
        ],
      ),
    );
  }

  Widget _buildProfilePhotoPicker() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8E4DA),
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: const Icon(
                Icons.person,
                size: 50,
                color: Color(0xFFB5AD9C),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // hook up image picker later
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _green,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "Add Profile Photo",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          textAlign: TextAlign.center,
        ),
        const Text(
          "(Optional)",
          style: TextStyle(color: _green, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey, size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE0DCD0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _green, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomePage(),
                    ),
                    );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginRow() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Already have an account? ",
            style: TextStyle(color: Colors.grey),
          ),
          GestureDetector(
            onTap: () {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen(),
                    ),
                    );
            },
            child: const Text(
              "Log In",
              style: TextStyle(
                color: _green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}