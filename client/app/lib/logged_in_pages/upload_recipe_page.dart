import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/util/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:app/widgets/loading_frame.dart';
import 'package:app/util/session_manager.dart';

import 'package:http/http.dart' as http;

class UploadRecipePage extends StatefulWidget {

  const UploadRecipePage({super.key});

  @override
  State<StatefulWidget> createState() => _UploadRecipePageState();
}

class _UploadRecipePageState extends State<UploadRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<LoadingFrameState> _loadingFrameKey = GlobalKey();
  final ImagePicker _picker = ImagePicker(); // image picker instance

  String? _title;
  String? _description;
  Uint8List? _imageBytes;
  
  // Method to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    Uint8List? loadedImageBytes = await pickedFile?.readAsBytes();

    if (pickedFile != null) {
      setState(() {
        _imageBytes = loadedImageBytes;
      });
    }
  }

  // Method to handle form submission
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (_imageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return;
      }
    
      final uploadURL = Uri.parse(APIConstants.uploadRecipeEndpoint);

      // Show the loading screen when the button is pressed
      showDialog(
        context: context,
        barrierDismissible: false,  // Prevent closing by tapping outside
        builder: (BuildContext context) {
          return LoadingFrame(
            key: _loadingFrameKey,
            message: "Publishing your recipe...",
          ); 
        },
      );
      // Upload the data to the server.
      String base64Image = base64Encode(_imageBytes!);

      final payload = {
        'title' : _title,
        'description' : _description,
        'image_bytes' : base64Image,
        'authentication_token' : SessionManager().authenticationToken
      };

      int responseStatusCode = 0;

      try {
        final response = await http.post(
          uploadURL,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(payload),
        );
        responseStatusCode = response.statusCode;

        // If return code is 200 that means we have successfully published our recipe
        final dynamic data;
        if (response.statusCode == 201) {
          data = jsonDecode(response.body);
          _loadingFrameKey.currentState?.updateMessage("Your recipe has been published!");
        } else {
          data = jsonDecode(response.body);
          _loadingFrameKey.currentState?.updateMessage("An error has occured: ${data['error']}");
        }
      } catch (e) {
        _loadingFrameKey.currentState?.updateMessage("Failed to publish recipe: $e");
      }

      await Future.delayed(const Duration(seconds: 3));
      // if the publish was successful we want to change our page to the recipes page after 3 seconds 
      // we also want to remember to remove the loading ui
      // if it is unauthorized then force logout
      if (responseStatusCode == 401) {
        // unauthorized access
        Navigator.popUntil(context, ModalRoute.withName('/'));  

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unauthorized access detected, please login again.')),
        );
      } else {
        if (!mounted) {return;}
        Navigator.of(context).pop(); // Dismiss the dialog      
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Upload Your Recipe!', 
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            backgroundColor: Colors.transparent,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                decoration: InputDecoration(
                  label : const Text("Recipe Title"),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder()
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Recipe Description',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder()
                ),
                maxLines: 8, // Multiline input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value;
                },
              ),
              const SizedBox(height: 16),

              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _imageBytes == null
                      ? const Center(
                          child: Text(
                            'Tap to select an image',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : Image.memory(
                          _imageBytes!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}