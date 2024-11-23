// mealscreen.dart
import 'package:flutter/material.dart';
import 'package:meal/Models/cart.dart';
import 'package:meal/Models/meals.dart';
import 'package:meal/widget/mealItems.dart';
// Import the cart singleton

class Mealscreen extends StatefulWidget {
  Mealscreen(
      {super.key,
      this.title,
      required this.meals,
      required this.onSelectFavourite});

  final void Function(Meal meal) onSelectFavourite;
  final String? title;
  final List<Meal> meals;

  @override
  _MealscreenState createState() => _MealscreenState();
}

class _MealscreenState extends State<Mealscreen> {
  void _addToCart(Meal meal) {
    // Get the singleton instance
    Cart.addMeal(meal); // Add meal to the cart list
    // print(cart.getMeals()); // Print the cart meals
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: widget.meals.length,
      itemBuilder: (ctx, index) => Mealitems(
        meal: widget.meals[index],
        onfoodclick: _addToCart, // Pass method to add meal to cart
      ),
    );

    if (widget.meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Uh oh... nothing here',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(),
            Text(
              'Try selecting different Category',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      );
    }

    if (widget.title == null) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Show the cart items in a dialog or navigate to the cart screen
              // _showCartDialog(contexft);
            },
          ),
        ],
      ),
      body: content,
    );
  }

  // void _showCartDialog(BuildContext context) {
  //   Cart cart = Cart(); // Get the singleton instance
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: Text('Cart Items'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: cart.getMeals().map((meal) {
  //           return ListTile(
  //             title: Text(meal.mealName),
  //             subtitle: Text('₹${meal.price}'),
  //           );
  //         }).toList(),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(ctx).pop(),
  //           child: Text('Close'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
