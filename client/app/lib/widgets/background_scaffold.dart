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
          Container(
            width : double.infinity,
            height : double.infinity,
            padding: const EdgeInsets.all(15.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 255, 128, 0),
                  Color.fromARGB(255, 255, 128, 0),
                ]
              ),
            ),
            child: Image.asset(
              "assets/images/background_texture.png",
              width: double.infinity,
              height: double.infinity,
              color: const Color.fromARGB(82, 155, 78, 0),
              fit : BoxFit.cover,
            ),
          ),
          SafeArea(
            child: child!,
          )
        ],
      ),

    );
  }
}