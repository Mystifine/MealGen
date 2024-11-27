
import 'package:flutter/material.dart';

import 'package:app/widgets/home_menu_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onPageSelected});

  // callback to setState for main screen
  final Function(int) onPageSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "What will you be cooking today?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),

        Expanded(
          child: GridView.count(
            crossAxisCount: 2, // number of columns
            crossAxisSpacing: 20,
            mainAxisSpacing: 20.0,
            padding: EdgeInsets.all(16.0),
            children: [
              HomeMenuButton(
                buttonIcon: Icons.person, 
                buttonText: 'Profile', 
                onPressed: () {
                  onPageSelected(0);
                },
              ),
              HomeMenuButton(
                buttonIcon: Icons.local_pizza, 
                buttonText: 'Recipes', 
                onPressed: () {
                  onPageSelected(1);
                },
              ),
              HomeMenuButton(
                buttonIcon: Icons.upload, 
                buttonText: 'Upload Recipe', 
                onPressed: () {
                  onPageSelected(2);
                }
              ),
              HomeMenuButton(
                buttonIcon: Icons.support_agent, 
                buttonText: 'Support', 
                onPressed: () {
                  onPageSelected(0);
                },
              ),
              HomeMenuButton(
                buttonIcon: Icons.settings, 
                buttonText: 'Settings', 
                onPressed: () {
                  onPageSelected(0);
                },
              ),
            ],
          )
        )
      ],
    );
  }
}