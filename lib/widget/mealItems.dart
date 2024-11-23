import 'package:flutter/material.dart';
import 'package:meal/Models/cart.dart';
import 'package:meal/Models/meals.dart';

class Mealitems extends StatelessWidget {
  Mealitems({super.key, required this.meal, required this.onfoodclick});

  final Meal meal;
  final void Function(Meal meal) onfoodclick;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 4,
      color: Color.fromARGB(255, 210, 203, 203),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.mealName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '₹${meal.price}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Check if the meal is already in the cart
                      bool isAlreadyInCart = Cart.allMeals
                          .any((cartMeal) => cartMeal.id == meal.id);

                      if (isAlreadyInCart) {
                        // Show snackbar for already in cart
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  '${meal.mealName} is already in the cart!'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.green),
                        );
                      } else {
                        // Show snackbar for added to cart
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${meal.mealName} added to cart!'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Add meal to the cart
                        onfoodclick(meal);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Black button background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                meal.URL,
                height: 95,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
