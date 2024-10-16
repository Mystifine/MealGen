import 'package:app/screens/sign_in_screen.dart';
import 'package:app/screens/sign_up_screen.dart';
import 'package:app/widgets/background_scaffold.dart';
import 'package:app/widgets/welcome_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
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
                        text: "Welcome Back!\n",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 45.0,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      TextSpan(
                        text: "Enter your login information below.",
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
          ),
          const Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: WelcomeButton(
                      buttonText: "Sign In", 
                      backgroundColor: Colors.transparent, 
                      targetScreen: SignInScreen()
                    )
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: "Sign Up", 
                      backgroundColor: Colors.white, 
                      targetScreen: SignUpScreen()
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}