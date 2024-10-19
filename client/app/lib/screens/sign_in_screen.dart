import 'package:app/widgets/background_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:app/theme/theme.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

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
              padding: const EdgeInsets.fromLTRB(25, 50, 25, 20),
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
                      
                      const SizedBox(height: 40,),
                      
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter valid username";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label : const Text("Username/Email"),
                          hintText: "Enter your username or email address",
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter valid username";
                          }
                          return null;
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
                          onPressed: () {
                            if (_formSignInKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Logging you in...")
                                )
                              );
                            }
                          }, 
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
                              "Sign up with",
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
                            child: Text(
                              "Sign up",
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