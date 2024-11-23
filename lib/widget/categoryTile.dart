import 'dart:math';

import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String categoryName;
  static int colorIndex = 0;
  final void Function() onCategorySelect;
  List Color = [
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.lightBlue,
    Colors.teal,
    Colors.lightGreen
  ];

  CategoryTile({required this.categoryName, required this.onCategorySelect});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final i = random.nextInt(Color.length);
    colorIndex = (colorIndex + 1) % Color.length;

    return InkWell(
      onTap: onCategorySelect,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.all(2),
        color: Color[colorIndex],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Center(
            child: Text(
              categoryName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
