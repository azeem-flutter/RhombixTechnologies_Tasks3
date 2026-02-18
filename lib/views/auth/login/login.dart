import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/core/widgets/DividerText/divider_text.dart';
import 'package:trailmate/core/widgets/authText/auth_text.dart';
import 'package:trailmate/core/widgets/socialButton/social_button.dart';
import 'package:trailmate/navigation_menu.dart';
import 'package:trailmate/views/auth/signup/signup.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'The wilderness missed you.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 40),
                Text(
                  'Email Address',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color.fromARGB(255, 107, 107, 107),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 7),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'hello@wildbound.com',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Password',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color.fromARGB(255, 107, 107, 107)
                    ,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 7),

                const TextField(
                  decoration: InputDecoration(
                    hintText: '.........',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.to(NavigationMenu()),
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 20),
                const DividerText(text: 'or continue with'),
                const SizedBox(height: 20),
                const SocialButton(),
                const SizedBox(height: 20),
                AuthText(
                  text: 'New to TrailMate?',
                  onPressed: () => Get.to(const SignupScreen()),
                  authText: 'Join Now',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
