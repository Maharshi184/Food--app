import 'package:flutter/material.dart';
import 'package:meal/Models/Category.dart';
import 'package:meal/main.dart';

class Categorygriditem extends StatelessWidget {
  Categorygriditem({super.key, required this.category,required this.onCategorySelect});

  final void Function() onCategorySelect; 

  final Category category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCategorySelect,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              category.color.withOpacity(0.5),
              category.color.withOpacity(0.9)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          category.title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
    );
  }
}
