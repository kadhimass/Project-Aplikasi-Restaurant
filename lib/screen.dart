import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});
  
  @override
  State <Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen>{
  @override
    void initState() {
      super.initState();
}  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      body: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children : [
            Text(
              'Welcome to Warung Kita',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            ],
          ),
      );
  }
}
