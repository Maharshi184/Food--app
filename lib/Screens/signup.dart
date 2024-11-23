import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal/dbHelper/mogodb.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:provider/provider.dart';
import 'package:meal/dummydata/login_data.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isOTPSent = false;
  bool _isEmailValidated = false;

  void _sendOTP() async {
    if (_emailFormKey.currentState!.validate()) {
      await Provider.of<LoginData>(context, listen: false)
          .generateOtpAndSend(_emailController.text);
      setState(() {
        _isOTPSent = true;
      });
      Fluttertoast.showToast(
          msg: "OTP sent to ${_emailController.text}",
          backgroundColor: Colors.orange,
          textColor: Colors.black);
    }
  }

  void _validateOTP() {
    bool isValid = Provider.of<LoginData>(context, listen: false)
        .validateOtp(_otpController.text);
    if (isValid) {
      setState(() {
        _isEmailValidated = true;
        _isOTPSent = false;
      });
      Fluttertoast.showToast(msg: "Email validated! Please set your password.");
    } else {
      Fluttertoast.showToast(msg: "Invalid OTP! Please try again.");
    }
  }

  Future<void> _addCredentials(
      String name, String email, String password) async {
    // Add credentials to the local list
    // credentials.add(Login(id: 'j', Name: name, Email: email, Password: password));

    // Insert credentials into MongoDB
    var data = {'name': name, 'email': email, 'password': password};
    await mongodb.insertData(data);
    print('data');
  }

  void _signUp() async {
    if (_passwordFormKey.currentState!.validate()) {
      Provider.of<LoginData>(context, listen: false).addCredentials(
          'User', _emailController.text, _passwordController.text);
      Fluttertoast.showToast(msg: "Signed up successfully!");
      Navigator.pop(context); // Navigate back to login screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isEmailValidated
            ? Form(
                key: _passwordFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _nameFormKey,
                      child: TextFormField(
                        controller: _nameController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(labelText: 'Password'),
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
                      onPressed: () async {
                        print('Button pressed');
                        await _addCredentials(_nameController.text,
                            _emailController.text, _passwordController.text);
                        _signUp();
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              )
            : Form(
                key: _emailFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : 'Invalid email',
                    ),
                    SizedBox(height: 20),
                    _isOTPSent
                        ? Column(
                            children: [
                              TextFormField(
                                controller: _otpController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Enter OTP',
                                ),
                              ),
                              OtpTimerButton(
                                duration: 0,
                                onPressed: _validateOTP,
                                text: Text(
                                  'Validate OTP',
                                  style: TextStyle(color: Colors.black),
                                ),
                                buttonType: ButtonType.elevated_button,
                              ),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: _sendOTP,
                            child: Text('Send OTP'),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
