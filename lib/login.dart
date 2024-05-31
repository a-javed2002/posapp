import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text:"owais altaf");
  final _passwordController = TextEditingController(text:"123456");
  final AuthService _authService = AuthService(baseUrl: 'https://alarahi.nanotechnology.com.pk');

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final response = await _authService.login(username, password);
      //response.statusCode == 200
      print('Login successful: ');
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
      // Navigate to the next screen or show a success message
    } catch (e) {
      print('Login failed: $e');
      Navigator.pop(context);
      // Show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              // obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
