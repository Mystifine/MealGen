import 'package:flutter/material.dart';

class BackgroundScaffold extends StatelessWidget {
  const BackgroundScaffold({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.jpeg', 
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity, 
          ),
          SafeArea(
            child: child!,
          )
        ],
      ),

    );
  }
}