import 'package:app/theme/theme.dart';
import 'package:flutter/material.dart';

class LoadingFrame extends StatefulWidget {
  final String message;

  const LoadingFrame({super.key, required this.message});

  @override
  State<LoadingFrame> createState() {
    return LoadingFrameState();
  }
}

class LoadingFrameState extends State<LoadingFrame> {
  late String state = "Loading";
  late String currentMessage;

  @override
  void initState() {
    super.initState();
    currentMessage = widget.message;
  }

  void updateMessage(String newMessage) {
    setState(() {
      currentMessage = newMessage;
    });
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
    return buildLoadingFrame(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: lightColorScheme.primary,
          ),
          SizedBox(height: 26,),
          createLoadingText(currentMessage),
        ]
      )           
    );
  }
}