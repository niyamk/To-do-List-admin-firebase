import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/main.dart';
import 'package:get/get.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FocusNode myFocusNode = new FocusNode();
  void _navigateToHome() {
    // Define the valid username and password
    /*const validUsername = '00';
    const validPassword = '00';*/

    // Check if the entered username and password match the valid credentials
    if (_emailController.text == validUsername &&
        _passwordController.text == validPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Get.snackbar(
        "Error",
        "Invalid username or password",
        duration: Duration(milliseconds: 1300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 7),
              Image.asset(
                'assets/logo/logo.png',
                height: 150, // Adjust the height as needed
                width: 150, // Adjust the width as needed
              ),
              Spacer(flex: 1),
              TextField(
                focusNode: myFocusNode,
                controller: _emailController,
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Enter Your Username/Email',
                  labelText: 'Email or Username',
                ),
              ),
              Spacer(flex: 1),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'Enter Your Password',
                  labelText: 'Password',
                ),
              ),
              Spacer(flex: 1),
              ElevatedButton.icon(
                onPressed: _navigateToHome,
                icon: const Icon(Icons.login),
                label: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              Spacer(flex: 7),
            ],
          ),
        ),
      ),
    );
  }
}
