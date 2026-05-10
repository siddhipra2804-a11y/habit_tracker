import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'app_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Step 1: Controllers for inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Step 2: Validate Input
  bool _validateForm() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return false;
    }
    // Basic email format check
    if (!email.contains('@') || !email.contains('.')) {
      _showError('Please enter a valid email address');
      return false;
    }
    return true;
  }

  // Step 3: Verify Credentials with SharedPreferences
  Future<void> _authenticateUser() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Retrieve the data we saved during Sign-Up
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');

    if (storedEmail == _emailController.text && storedPassword == _passwordController.text) {
      if (mounted) {
        // SUCCESS: Navigate to the home/dashboard (create this route next!)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );
        // context.go('/home'); 
      }
    } else {
      _showError('Invalid email or password');
    }
  }

  // Step 4: Handle Login Button Press
  void _handleLogin() {
    if (_validateForm()) {
      _authenticateUser();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: Padding(
        padding: AppStyles.screenPadding,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Welcome Back", style: AppStyles.headerStyle),
                const SizedBox(height: 40),
                
                // Step 1: UI Components
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 25),

                // Login Button
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Login'),
                ),

                const SizedBox(height: 15),

                // Step 1: GestureDetector/TextButton for Navigation
                GestureDetector(
                  onTap: () => context.push('/signup'),
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(
                      color: AppStyles.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}