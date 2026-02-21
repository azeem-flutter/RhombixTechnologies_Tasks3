import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const SocialButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: OutlinedButton(
        onPressed: onPressed,
        child: const Text('Continue with Google'),
      ),
    );
  }
}
