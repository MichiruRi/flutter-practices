import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_area_idk/models/result.dart';
import 'package:testing_area_idk/screens/listing_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => Result())],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ListingScreen(),
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
