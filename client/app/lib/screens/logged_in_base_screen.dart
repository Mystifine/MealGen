import 'package:app/logged_in_pages/upload_recipe_page.dart';
import 'package:flutter/material.dart';

import 'package:app/logged_in_pages/home_page.dart';
import 'package:app/logged_in_pages/recipes_page.dart';

import 'package:app/theme/theme.dart';

class LoggedInBaseScreen extends StatefulWidget {
  const LoggedInBaseScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoggedInBaseScreenState();
} 

class _LoggedInBaseScreenState extends State<LoggedInBaseScreen> {
  // selectedIndex to manage the selected page
  int _selectedMenuIndex = 0;
  int _selectedPageIndex = 0;

  // changes the page to the provided index
  void _changePages(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // updates the selected menu index which triggers a page change
  void _onMenuButtonPressed(int index) {
    setState(() {
      _selectedMenuIndex = index;
    });
    _changePages(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: lightColorScheme.primary,
      appBar: AppBar(
        backgroundColor: lightColorScheme.primary,
        title: Text(
          "MealGen",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
          )
        ),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: lightColorScheme.primary,
        currentIndex: _selectedMenuIndex,
        onTap: _onMenuButtonPressed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.local_pizza), label: 'Recipes'),
        ],
      ),
      body: Stack(
        children: [
          // Background for all the pages
          Container(
            width : double.infinity,
            height : double.infinity,
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
          IndexedStack(
            index: _selectedPageIndex,
            children: [
              HomePage(
                selectMenuItem: _onMenuButtonPressed,
                changePages: _changePages,
              ),
              RecipePageScreen(
                selectMenuItem: _onMenuButtonPressed,
                changePages: _changePages,
              ),
              UploadRecipePage(), // Placeholder for Profile Page
              Container(), // Placeholder for Support Page
            ],
          ),
        ],
      ),
    );
  }
}