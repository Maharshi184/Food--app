import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'package:meal/dbHelper/mogodb.dart';

class LoginData extends ChangeNotifier {
  String? _generatedOtp;
  bool _isOtpValid = false;

  // bool checkCredentials(String email, String password) {
  //   return credentials.any(
  //     (login) => login.Email == email && login.Password == password,
  //   );
  // }
  Future<bool> checkCredentials(String email, String password) async {
    var user = await mongodb.userCollection
        .findOne({'Email': email, 'Password': password});
    return user != null;
  }

  Future<void> addCredentials(
      String name, String email, String password) async {
    try {
      // Create the data object
      var data = {
        'Name': name,
        'Email': email,
        'Password': password,
      };

      // Ensure all values are strings
      data = data.map((key, value) => MapEntry(key, value.toString()));

      print('Attempting to insert data: $data');

      // Insert credentials into MongoDB
      var result = await mongodb.ordersCollection.insert(data);

      print('Insert operation completed. Result: $result');

      if (result != null) {
        if (result is Map<String, dynamic>) {
          print('Inserted document: ${result.toString()}');
          if (result.containsKey('_id')) {
            print('Inserted document ID: ${result['_id']}');
          } else {
            print('No _id field found in the result');
          }
        } else {
          print('Unexpected result type: ${result.runtimeType}');
        }
      } else {
        print('Insert operation returned null');
      }

      print('Credentials added successfully');
      notifyListeners();
    } catch (e, stackTrace) {
      print('Error during insertion: $e');
      print('Stack trace: $stackTrace');
      // Rethrow the error if you want to handle it in the calling code
      // rethrow;
    }
  }

  String _generateOtp() {
    var rng = Random();
    return (rng.nextInt(900000) + 100000).toString(); // 6-digit OTP
  }

  Future<void> generateOtpAndSend(String email) async {
    _generatedOtp = _generateOtp();
    _isOtpValid = true;

    // SMTP server configuration
    String username = 'kachhimaharshi20@gmail.com';
    String password = 'your_mail_password';
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'kachhimaharshi20@gmail.com')
      ..recipients.add(email)
      ..subject = 'Your OTP Code'
      ..text = 'Your OTP code is: $_generatedOtp';

    try {
      await send(message, smtpServer);
      print('OTP sent: $_generatedOtp');
    } on MailerException catch (e) {
      print('Message not sent. $e');
    }
  }

  bool validateOtp(String otp) {
    if (_isOtpValid && otp == _generatedOtp) {
      _isOtpValid = false;
      return true;
    }
    return false;
  }
}
