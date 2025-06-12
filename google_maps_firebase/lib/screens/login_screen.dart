import 'package:flutter/material.dart';
import 'package:google_maps_firebase/screens/google_maps_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nameCtrl = TextEditingController();

  void login() async {
    if (nameCtrl.text.isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GoogleMapsScreen(name: nameCtrl.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: nameCtrl,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Login',
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => login(),
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
