import 'package:app/screens/sign_in_screen.dart';
import 'package:app/screens/sign_up_screen.dart';
import 'package:app/widgets/background_scaffold.dart';
import 'package:app/widgets/introduction_button.dart';
import 'package:flutter/material.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/app_icon.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),     
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 40.0
            ),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "MealGen\n",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45.0,
                        fontWeight: FontWeight.w600,
                      )
                    ),
                    TextSpan(
                      text: "Get started below.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )
                    )
                  ]
                )
              )
            ),
          ),
          const SizedBox(height: 40,),
          const SizedBox(
            width: 300,
            child: IntroductionButton(
              buttonText: "Login", 
              backgroundColor: Color.fromARGB(255, 255, 0, 43), 
              targetScreen: SignInScreen()
            )
          ),
          const SizedBox(height: 20,),
          const SizedBox(
            width: 300,
            child: IntroductionButton(
              buttonText: "Sign Up", 
              backgroundColor: Color.fromARGB(255, 50, 200, 132), 
              targetScreen: SignUpScreen()
            )
          ),
          
        ],
      ),
    );
  }
}