import 'package:flutter/material.dart';

class DividerText extends StatelessWidget {
  const DividerText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Flexible(
          child: Divider(indent: 40, endIndent: 5, color: Colors.black),
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: const Color.fromARGB(255, 107, 107, 107),
            fontWeight: FontWeight.bold,
          ),
        ),
        const Flexible(
          child: Divider(indent: 5, endIndent: 40, color: Colors.black),
        ),
      ],
    );
  }
}
