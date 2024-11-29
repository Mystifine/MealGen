import 'package:app/routes/app_routes.dart';

import 'package:app/util/validators.dart';
import 'package:app/util/token_manager.dart';
import 'package:app/util/api_constants.dart';

import 'package:app/widgets/background_scaffold.dart';
import 'package:app/widgets/loading_frame.dart';

import 'package:app/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:app/screens/logged_in_base_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<LoadingFrameState> _loadingFrameKey = GlobalKey();

  final _formSignInKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  
  String? _username = "";
  String? _password = "";

  Future<void> _submitForm() async {
    // Validate the descendant fields
    if (!_formSignInKey.currentState!.validate()) {
      return;
    }

    // Save the form state
    _formSignInKey.currentState!.save();

    final loginURL = Uri.parse(APIConstants.loginEndpoint);

    // Show the loading screen when the button is pressed
    showDialog(
      context: context,
      barrierDismissible: false,  // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return LoadingFrame(
          key: _loadingFrameKey,
          message: "Loading your data...",
        ); 
      },
    );

    // Set up http request to log in.
    final payload = {
      'username' : _username,
      'password' : _password,
    };

    bool loginSuccess = false;

    try {
      final response = await http.post(
        loginURL,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      // If return code is 200 that means we have logged in!
      final dynamic data;
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        TokenManager().authenticationToken = data['authentication_token'];
        loginSuccess = true;
        _loadingFrameKey.currentState?.updateMessage("Welcome $_username!");
      } else {
        data = jsonDecode(response.body);
        _loadingFrameKey.currentState?.updateMessage("Failed to load data: ${data['error']} ${response.statusCode}");
      }
    } catch (e) {
      _loadingFrameKey.currentState?.updateMessage("Failed to load data: $e");
    }

    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return; // Ensure widget is still mounted
    Navigator.of(context).pop(); // Dismiss the dialog

    if (loginSuccess) {
      Navigator.pushReplacementNamed(
        context, 
        '/logged_in'
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10,)
          ),
          Expanded(
            flex : 8,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 35, 25, 20),
              width: double.infinity,
              decoration: const BoxDecoration(
                color : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Enter Login Credentials',
                        style: TextStyle(
                          color: lightColorScheme.primary,
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 30,),
                      
                      TextFormField(
                        validator: Validators.validateUsername,
                        onSaved: (newValue) {
                          _username = newValue;
                        },
                        decoration: InputDecoration(
                          label : const Text("Username"),
                          hintText: "Enter your username",
                          hintStyle: const TextStyle(
                            color: Colors.black26
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          )
                        ),
                      ),

                      const SizedBox(height: 20,),
                      
                      TextFormField(
                        obscureText: !_isPasswordVisible,
                        obscuringCharacter: "*",
                        validator: Validators.validatePassword,
                        onSaved: (newValue) {
                          _password = newValue;
                        },
                        decoration: InputDecoration(
                          label : const Text("Password"),
                          hintText: "Enter your password.",
                          hintStyle: const TextStyle(
                            color: Colors.black26
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          )
                        ),
                      ),
                      const SizedBox(height: 10),      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _isPasswordVisible, 
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isPasswordVisible = value!;
                                  });
                                },
                                activeColor: lightColorScheme.primary,
                              ),
                              const Text(
                                "Show Password",
                                style: TextStyle(
                                  color : Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            child: Text(
                              "Forget Password?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightColorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),  
                            ),
                          ),
                          onPressed: _submitForm,
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          )
                        ),
                      ),
                      const SizedBox(height: 20,),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Divider(
                              color: Color.fromARGB(80, 0, 0, 0),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Login with",
                              style: TextStyle(
                                color: Color.fromARGB(255,100,100,100),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Divider(
                              color: Color.fromARGB(80, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesome.facebook_brand, size: 50, color: Color.fromARGB(255, 0, 0, 0),),
                          SizedBox(width: 15,),
                          Icon(FontAwesome.twitter_brand, size: 50, color: Color.fromARGB(255, 0, 0, 0),),
                          SizedBox(width: 15,),
                          Icon(FontAwesome.google_brand, size: 50, color: Color.fromARGB(255, 0, 0, 0),),                          
                          SizedBox(width: 15,),
                          Icon(FontAwesome.github_brand, size: 50, color: Color.fromARGB(255, 0, 0, 0),),   
                          SizedBox(width: 15,),
                          Icon(FontAwesome.apple_brand, size: 50, color: Color.fromARGB(255, 0, 0, 0),),                         
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? "
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context,AppRoutes.signup,);
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  } 
}