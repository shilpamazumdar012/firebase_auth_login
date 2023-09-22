import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: Column(
          children: [
            Text('Welcome Screen', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
