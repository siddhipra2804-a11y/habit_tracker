import 'package:flutter/material.dart';
import 'app_styles.dart'; // Import your styles

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: Padding(
        padding: AppStyles.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text("Welcome Back", style: AppStyles.headerStyle),
            const Text("Log in to track your habits", style: AppStyles.bodyStyle),
            const SizedBox(height: AppStyles.elementSpacing),
            
            // Reusable decorated container
            Container(
              padding: const EdgeInsets.all(AppStyles.defaultPadding),
              decoration: AppStyles.cardDecoration,
              child: const TextField(
                decoration: InputDecoration(hintText: "Email"),
              ),

              ElevatedButton(
                onPressed: () => context.push('/signup'),
                child: const Text("Don't have an account? Sign Up"),
            )
            ),
          ],
        ),
      ),
    );
  }
}