import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Welcome to Shop App"),
            const CircularProgressIndicator(
              color: Color.fromARGB(
                255,
                248,
                204,
                102,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
