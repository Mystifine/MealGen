import 'package:app/theme/theme.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

class RecipeDetailPage extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final Future<void> Function(Map<String, dynamic> recipe) toggleRecipeLikeCallback;

  const RecipeDetailPage({
    super.key,
    required this.recipe,
    required this.toggleRecipeLikeCallback,
  });

  @override
  State<StatefulWidget> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      backgroundColor: lightColorScheme.primary,
      floatingActionButton: FloatingActionButton(
        tooltip: "Like(s): ${widget.recipe['likes_count']}",
        child: Icon(
          color: widget.recipe['is_liked'] ? Colors.lightBlue : Colors.grey,
          Icons.thumb_up
        ),
        onPressed: () async {   
          await widget.toggleRecipeLikeCallback(widget.recipe);  
                 
          setState(() {});
        }
      ),
      appBar: AppBar(
        backgroundColor: lightColorScheme.primary,
        title: Text(widget.recipe['title']),
      ),
      body: Stack(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.memory(
                    base64Decode(widget.recipe["image_bytes"]!),
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ), // Recipe image

                  SizedBox(height: 16),

                  Text(
                    widget.recipe['title'],
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    'Author: ${widget.recipe['author_name']}',
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    widget.recipe['description'],
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}