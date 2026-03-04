import 'package:flutter/material.dart';

class IconNumberButton extends StatelessWidget {
  final IconData iconData;
  final int number;
  final VoidCallback onPressed;

  IconNumberButton({
    Key? key,
    required this.iconData,
    required this.number,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: .center,
        children: [
          Icon(iconData, color: Colors.white),
          Text(
            "$number",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
