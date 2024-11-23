import 'package:flutter/material.dart';
import 'package:meal/Models/meals.dart';

class Order extends StatefulWidget {
  final Meal meal;

  final void Function(Meal meal) onfoodclick;
  final void Function(Meal meal)
      onDeleteMeal; // Function to delete the meal from the list

  Order({
    super.key,
    required this.meal,
    required this.onfoodclick,
    required this.onDeleteMeal,
    // Pass the delete function from parent
  });

  @override
  _OrderState createState() => _OrderState();

  int getQuantity() {
    final state = createState();
    return state.getQuantity();
  }
}

class _OrderState extends State<Order> {
  int quantity = 1; // Initial quantity is set to 1

  int getQuantity() {
    return quantity;
  }

  void _increaseQuantity() {
    setState(() {
      quantity += 1;
      widget.meal.quantity += 1;
      print(widget.meal.quantity);
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (quantity > 1) {
        widget.meal.quantity -= 1;
        quantity -= 1;
      } else {
        // If quantity is less than or equal to 1, remove the card
        widget.onDeleteMeal(widget.meal); // Call the delete function
      }
    });
  }

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
                    widget.meal.mealName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '₹${widget.meal.price * quantity}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Conditionally showing either 'Add' button or quantity selector
                  quantity == 0
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              quantity =
                                  1; // Set initial quantity when 'Add' is pressed
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.black, // Black button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: _decreaseQuantity,
                              icon: Icon(Icons.remove, color: Colors.orange),
                            ),
                            Text(
                              '$quantity',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                            IconButton(
                              onPressed: _increaseQuantity,
                              icon: Icon(Icons.add, color: Colors.orange),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            SizedBox(width: 8),
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.meal.URL,
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
