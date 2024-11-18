import 'package:app/theme/theme.dart';
import 'package:flutter/material.dart';

class LoadingFrame extends StatefulWidget {
  const LoadingFrame({super.key});

  @override
  State<LoadingFrame> createState() {
    return _LoadingFrameState();
  }
}

class _LoadingFrameState extends State<LoadingFrame> {
  late Future<String>? futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();  // Call fetchData when the widget is created
  }

  Future<String> fetchData() async {
    // Simulate network call
    await Future.delayed(Duration(seconds: 3));
    return Future.value("Data Loaded!");
  }

  static Widget createLoadingText(String message) {
    return Text(
      message, 
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget buildLoadingFrame(Widget child) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,  
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        width: 250,
        height: 250,
        child: child,
      ), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<String>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading widget while waiting for the future
            return buildLoadingFrame(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: lightColorScheme.primary,
                  ),
                  SizedBox(height: 26,),
                  createLoadingText("Loading your data..."),
                ]
              )           
            );
          } else if (snapshot.hasError) {
            return buildLoadingFrame(createLoadingText('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return buildLoadingFrame(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    alignment: Alignment.center,
                    'assets/images/checkmark_icon.png',
                    color: lightColorScheme.primary,
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(height: 26,),
                  createLoadingText(snapshot.data!)
                ]
              )
            );
          }
          return buildLoadingFrame(Container()); // Fallback in case of unknown state
        },
      ),
    );
  }
}