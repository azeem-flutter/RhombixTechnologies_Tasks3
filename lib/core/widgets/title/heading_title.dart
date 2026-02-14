import 'package:flutter/material.dart';

class HeadingTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const HeadingTitle({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontSize: 18),
        ),

        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: Text(
              'View All',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color.fromARGB(255, 1, 70, 18),
              ),
            ),
          ),
      ],
    );
  }
}
