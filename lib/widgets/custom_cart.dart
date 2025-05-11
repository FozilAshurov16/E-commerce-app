import 'package:flutter/material.dart';

class CustomCart extends StatelessWidget {
  final Widget child;
  final String number;
  const CustomCart({
    super.key,
    required this.child,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 3,
          right: -3,
          left: 12,
          child: Container(
            alignment: Alignment.center,
            // padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color.fromARGB(
                255,
                248,
                204,
                102,
              ),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
