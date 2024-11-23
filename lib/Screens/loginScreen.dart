import 'package:flutter/material.dart';
import 'package:meal/Screens/tabs.dart';
import 'package:meal/dbHelper/mogodb.dart';
import 'package:meal/Models/Userdata.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login1() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      print('Entered Email: $email');
      print('Entered Password: $password');

      var data = await mongodb.userCollection.find().toList();
      print('Existing data in MongoDB collection:');
      data.forEach((user) {
        print(user);
      });

      var user = await mongodb.userCollection.findOne({
        'email': email,
        'password': password,
      });

      print('Fetched user: $user');

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  tabs()), // Navigate to TabsScreen after successful login
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Invalid Email/Password!',
            style: TextStyle(color: Colors.black),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Login'),
          backgroundColor: const Color.fromARGB(255, 29, 133, 219),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail),
                      prefixIconColor: Color.fromARGB(179, 70, 57, 57),
                      labelText: 'Email address',
                      labelStyle:
                          TextStyle(color: Color.fromARGB(179, 70, 57, 57)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Oval shape
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      prefixIconColor: Color.fromARGB(179, 70, 57, 57),
                      labelText: 'Password',
                      labelStyle:
                          TextStyle(color: Color.fromARGB(179, 70, 57, 57)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Oval shape
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login1,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                      _emailController.clear();
                      _passwordController.clear();
                    },
                    child: Text(
                      " No account? Create one!",
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/Login1');
                      _emailController.clear();
                      _passwordController.clear();
                    },
                    icon: Icon(Icons.restaurant,
                        color: Colors.orange), // Icon similar to a chef hat
                    label: Text(
                      'Restaurant Owner?',
                      style: TextStyle(color: Colors.orange),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Color(0xFFFFF4E0), // Light peach-like color
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Rounded corners
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
