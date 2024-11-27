import 'package:flutter/material.dart';

import 'package:app/logged_in_pages/upload_recipe_page.dart';

class RecipesPage extends StatelessWidget {
  final List<Map<String, String>> recipes;
  final bool isLoading;
  final VoidCallback loadMoreRecipes;

  // callback to setState for main screen
  final Function(int) onPageSelected;

  const RecipesPage({
    super.key,
    required this.recipes,
    required this.isLoading,
    required this.loadMoreRecipes,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onPageSelected(2);
        },
        tooltip: 'Create new recipe.',
        child: const Icon(Icons.add),
      ),
      body : Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                    !isLoading) {
                  loadMoreRecipes(); // Load more recipes when scrolled to the bottom
                }
                return true;
              },
              child: ListView.builder(
                itemCount: recipes.length + 1, // Include 1 for loading indicator
                itemBuilder: (context, index) {
                  if (index == recipes.length) {
                    return isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink();
                  }
                  final recipe = recipes[index];
                  return Card(
                    margin: const EdgeInsets.all(12.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            recipe["imageUrl"]!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe["title"]!,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                recipe["description"]!,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      )
    );
  }
} 