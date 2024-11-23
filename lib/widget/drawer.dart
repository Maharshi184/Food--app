import 'package:flutter/material.dart';

class getDrawer extends StatelessWidget {
  getDrawer({super.key, required this.onchange});

  final void Function(String identifier) onchange;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 194, 104, 25),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.food_bank,
                  size: 48,
                ),
                Text(
                  'Cooking Up!',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.restaurant,
              size: 24,
              color: Colors.blue,
            ),
            title: Text(
              'Coming soon....',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
          Spacer(), // Pushes the logout button to the bottom
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 24,
              color: Colors.red,
            ),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              // Navigate to the login screen
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
