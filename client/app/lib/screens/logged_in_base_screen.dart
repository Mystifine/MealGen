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
  int _selectedIndex = 0;

  // Recipes Information
  List<Map<String, String>> _recipes = [];
  bool _isLoading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true;
    });

    // fetch recipes
    final newRecipes = List.generate(10, (index) {
      final recipeIndex = ((_page - 1) * 10) + index + 1;
      return {
        "title": "Recipe $recipeIndex",
        "description": "Description for Recipe $recipeIndex",
        "imageUrl": "https://via.placeholder.com/300x200.png?text=Recipe+$recipeIndex"
      };
    });

    setState(() {
      _recipes.addAll(newRecipes);
      _isLoading = false;
      _page++;
    });
    
  }

  void _onPageButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        currentIndex: _selectedIndex,
        onTap: _onPageButtonPressed,
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
            index: _selectedIndex,
            children: [
              HomePage(onPageSelected: _onPageButtonPressed),
              RecipesPage(
                recipes: _recipes,
                isLoading: _isLoading,
                loadMoreRecipes: _fetchRecipes,
                onPageSelected: _onPageButtonPressed,
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