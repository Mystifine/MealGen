import 'package:app/util/api_constants.dart';
import 'package:app/logged_in_pages/upload_recipe_page.dart';
import 'package:app/util/session_manager.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipePageScreen extends StatefulWidget {
  // callback to setState for main screen
  final Function(int) changePages;
  final Function(int) selectMenuItem;

  final int pageSize = 10;

  const RecipePageScreen({
    super.key,
    required this.changePages,
    required this.selectMenuItem
  });

  @override
  State<StatefulWidget> createState() => _RecipesPageScreenState();
}

class _RecipesPageScreenState extends State<RecipePageScreen> {
  // Recipes Information
  final List<Map<String, dynamic>> _recipes = [];
  bool _isLoading = false;
  int _page = 1;

  // Sort options for recipes
  String _selectedSortOption = 'Date';
  final List<String> _sortOptions = ['Date', 'Likes'];

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _likeRecipe(String recipeId) async {

  }

  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, String> sortOptionDictionary = {
      'Date' : 'publish_time',
      'Likes' : 'likes_count',
    }; 

    // Set up http request to log in.
    final String sortOption = sortOptionDictionary[_selectedSortOption] ?? 'publish_time';
    final getRecipeURL = Uri.parse(APIConstants.getRecipesEndpoint(SessionManager().userid!, _page, widget.pageSize, sortOption));

    try {
      final response = await http.get(
        getRecipeURL,
        headers: {"Content-Type": "application/json"},
      );

      // If return code is 200 that means we have retrieved it successfully
      final List<dynamic> data;
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        setState(() {
          _recipes.addAll(data.map((item) {
            return {
              '_id' : item['_id'],
              "title": item["title"] ?? "",
              "description": item["description"] ?? "",
              'image_bytes' : item['image_bytes'] ?? '',
              'publish_time' : item['publish_time'],
              'is_liked' : item['is_liked'] ?? false,
              "likes_count": item["likes_count"] ?? 0, // Ensure likes_count is a string
            };
          }).toList());
          _page++;
        });
      } else {
      }
    } catch (e) {
      print('An error has occured: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _sortRecipes(String sortOption) {
    setState(() {
      _selectedSortOption = sortOption;
      
      // reset the list if we change sort mode and trigger and fetch request.
      _page = 1;
      _recipes.clear();

      _fetchRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.changePages(2);
        },
        tooltip: 'Create new recipe.',
        child: const Icon(Icons.add),
      ),
      body : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16,4,16,4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Sort by:",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedSortOption,
                  icon: const Icon(Icons.arrow_drop_down),
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  items: _sortOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(), 
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _sortRecipes(newValue);
                    }
                  }
                )
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                    !_isLoading) {
                  _fetchRecipes(); // Load more recipes when scrolled to the bottom
                }
                return true;
              },
              child: ListView.builder(
                itemCount: _recipes.length + 1, // Include 1 for loading indicator
                itemBuilder: (context, index) {
                  if (index == _recipes.length) {
                    return _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink();
                  }
                  final recipe = _recipes[index];
                  return Card(
                    margin: const EdgeInsets.all(12.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)
                          ),
                          child: recipe["image_bytes"].isNotEmpty ?
                            Image.memory(
                              base64Decode(recipe["image_bytes"]!),
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ) : 
                            Image.asset('assets/placeholder.png')
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    recipe["title"]!,
                                    style: const TextStyle(
                                      fontSize: 20, 
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.thumb_up,
                                          color: recipe["is_liked"] == true ? Colors.blue : Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // Toggle like status
                                            if (recipe["is_liked"] == true) {
                                              recipe["is_liked"] = false;
                                              recipe["likes_count"] = (recipe["likes_count"]!) - 1;
                                            } else {
                                              recipe["is_liked"] = true;
                                              recipe["likes_count"] = (recipe["likes_count"]!) + 1;
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                        "${recipe["likes_count"]} Likes",
                                        style: const TextStyle(
                                          fontSize: 16, 
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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