import 'package:flutter/material.dart';

class AuthText extends StatelessWidget {
  final String text, authText;
  final VoidCallback onPressed;
  const AuthText({
    super.key,
    required this.text,
    required this.onPressed,
    required this.authText,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 5),
          TextButton(
            onPressed: onPressed,
            child: Text(
              authText,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
