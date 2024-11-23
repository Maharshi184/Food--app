import 'package:flutter/material.dart';
import 'package:meal/Screens/OwnerScreen.dart';
import 'package:meal/Screens/tabs.dart'; // Import the necessary screens
import 'package:meal/dbHelper/mogodb.dart'; // Import your MongoDB helper

class OwnerLoginScreen extends StatefulWidget {
  @override
  _OwnerLoginScreenState createState() => _OwnerLoginScreenState();
}

class _OwnerLoginScreenState extends State<OwnerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginOwner() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      print('Entered Email (Owner): $email');
      print('Entered Password (Owner): $password');

      // Fetch all documents to verify if owner exists in the collection
      var data = await mongodb.ownerCollection.find().toList();
      // print('Existing owner data in MongoDB collection:');
      data.forEach((owner) {
        print(owner);
      });

      // Attempt to find the owner in the MongoDB collection
      var owner = await mongodb.ownerCollection.findOne({
        'email': email,
        'password': password,
      });

      print('Fetched owner: $owner');

      if (owner != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DashboardScreen()), // Navigate to TabsScreen or OwnerDashboard after successful login
        );
      } else {
        // If owner is not found, show error message
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Owner Login',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                style: TextStyle(color: Colors.orange),
                decoration: InputDecoration(
                  labelText: 'Email (Owner)',
                  labelStyle: TextStyle(color: Colors.orange),
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
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                style: TextStyle(color: Colors.orange),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.orange),
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
                onPressed: _loginOwner,
                child: Text(
                  'Login as Owner',
                  style: TextStyle(color: Colors.orange),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFFFF4E0), // Light peach-like color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // Rounded corners
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
