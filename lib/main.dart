import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal/Models/Category.dart';
import 'package:meal/Models/cart.dart';
import 'package:meal/Screens/Login1.dart';
import 'package:meal/Screens/categoryScreen.dart';
import 'package:meal/Screens/signup.dart';
import 'package:meal/Screens/tabs.dart';
import 'package:meal/Screens/loginScreen.dart';
import 'package:meal/Screens/OwnerScreen.dart';
import 'package:meal/dbHelper/mogodb.dart';
import 'package:meal/dummydata/login_data.dart';
import 'package:provider/provider.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await mongodb.connect();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginData()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/tabs': (context) => tabs(),
        '/login': (context) => LoginScreen(),
        '/Login1': (context) => OwnerLoginScreen(),
      },
    );
  }
}
