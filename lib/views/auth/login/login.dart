import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trailmate/controllers/auth/auth_controller.dart';
import 'package:trailmate/controllers/auth/login_controller.dart';
import 'package:trailmate/core/widgets/DividerText/divider_text.dart';
import 'package:trailmate/core/widgets/authText/auth_text.dart';
import 'package:trailmate/core/widgets/socialButton/social_button.dart';
import 'package:trailmate/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final authController = AuthController.instance;

    if (authController.currentUser.value != null) {
      Future.microtask(() => Get.offAllNamed(AppRoutes.navigation));
    }

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
                TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => controller.clearError(),
                  decoration: const InputDecoration(
                    hintText: 'hello@wildbound.com',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Password',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color.fromARGB(255, 107, 107, 107),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 7),

                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  onChanged: (_) => controller.clearError(),
                  decoration: const InputDecoration(
                    hintText: '.........',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 40),
                Obx(() {
                  if (authController.errorMessage.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      authController.errorMessage.value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: authController.isLoading.value
                          ? null
                          : controller.signIn,
                      child: authController.isLoading.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Login'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const DividerText(text: 'or continue with'),
                const SizedBox(height: 20),
                SocialButton(onPressed: controller.signInWithGoogle),
                const SizedBox(height: 20),
                AuthText(
                  text: 'New to TrailMate?',
                  onPressed: () => Get.toNamed(AppRoutes.signup),
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
