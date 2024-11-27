import 'package:app/screens/introduction_screen.dart';
import 'package:app/screens/logged_in_base_screen.dart';
import 'package:app/routes/app_routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealGen',
      debugShowCheckedModeBanner: false,

      initialRoute: AppRoutes.introduction,
      onGenerateRoute: AppRoutes.generateRoute,

      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: const Color.fromARGB(255, 255, 255, 255),  // Customize the color of the back arrow
            size: 30,  // Customize the size of the back arrow
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),

      home: const LoggedInBaseScreen(), //const IntroductionScreen(),
    );
  }
}
