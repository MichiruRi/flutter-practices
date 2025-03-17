import 'package:flutter/material.dart';
import 'package:web_api_localhost/screens/student_listing_screen.dart';

void main() {
  runApp(const WebApiApp());
}

class WebApiApp extends StatelessWidget {
  const WebApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentListingScreen(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
