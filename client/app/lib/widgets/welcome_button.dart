import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({super.key, required this.buttonText, required this.backgroundColor, required this.targetScreen});
  final String buttonText;
  final Color backgroundColor;
  final Widget targetScreen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap:() {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (e) => targetScreen
            )
          );
        },
        child: Container(
          padding: const EdgeInsets.all(25.0),
          decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
          )
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    );
  }
}