import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            width: 400,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10.0,
                  offset: const Offset(0, 5), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //iconLogin
                Container(
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: Colors.blue.withValues(alpha: 0.1)),
                  child: Icon(Icons.login, size: 100, color: Colors.blue),
                ),
                //username field
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
                  ),
                ),
                //password field
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                //login button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Perform login action
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logging in as ${_usernameController.text}')));
                      // Navigate to home screen or perform other actions
                      context.go('/home'); // Assuming you have a GoRouter set up
                    }
                  },
                  child: const Text('Login'),
                ),
                //forgot password link
                TextButton(
                  onPressed: () {
                    // Handle forgot password action
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Forgot Password Clicked')));
                  },
                  child: const Text('Forgot Password?'),
                ),
                // not a member link
                TextButton(
                  onPressed: () {
                    // Handle not a member action
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not a Member Clicked')));
                  },
                  child: const Text('Not a Member? Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
