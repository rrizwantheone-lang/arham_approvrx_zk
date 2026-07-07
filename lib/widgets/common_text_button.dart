import 'package:flutter/material.dart';

class CommonTextButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool underline;

  const CommonTextButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.underline = false, // 👈 default no underline
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        minimumSize: const Size(0, 25),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          //color: underline ? null : Theme.of(context).colorScheme.primary,
          //color: underline ? Colors.red : null,
          decoration:
          underline ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }
}
