import 'package:flutter/material.dart';

class IntroductionButton extends StatelessWidget {
  const IntroductionButton({super.key, required this.buttonText, required this.backgroundColor, required this.targetScreen});
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
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), 
                spreadRadius: 2,  
                blurRadius: 8,    
                offset: const Offset(3, 3), 
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
      )
    );
  }
}