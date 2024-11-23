import 'package:flutter/material.dart';
import 'package:meal/Models/cart.dart';
import 'package:meal/Models/meals.dart';
import 'package:meal/Screens/categoryScreen.dart';
import 'package:meal/dbHelper/mogodb.dart';
import 'package:meal/widget/drawer.dart';
import 'package:meal/widget/cardDesign.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class tabs extends StatefulWidget {
  tabs({super.key});

  @override
  State<tabs> createState() {
    return _TabsState();
  }
}

class _TabsState extends State<tabs> {
  final List<Meal> _favouriteMeals = [];
  var _title = 'Categories';
  int _selectedPageIndex = 0;
  int _tokenNumber = 1; // Starting token number

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      if (_selectedPageIndex == 0) {
        _title = 'Categories';
      } else if (_selectedPageIndex == 0) {
        _title = 'Cart';
      } else {
        _title = 'Orders';
      }
    });
  }

  Future<List<Meal>> _fetchAvailableMeals() async {
    try {
      final mongoData = await mongodb.foodCollection.find().toList();
      final List<Meal> mealList = (mongoData as List<dynamic>).map((mealData) {
        return Meal.fromMap(mealData as Map<String, dynamic>);
      }).toList();

      return mealList;
    } catch (e) {
      print('Error fetching meals: $e');
      return [];
    }
  }

  // Fetch user's name from MongoDB
  Future<String> _fetchUserName() async {
    try {
      // Assuming user has logged in, fetch the first user's name for demonstration
      final user = await mongodb.userCollection.findOne();
      return user['name'] as String;
    } catch (e) {
      print('Error fetching user data: $e');
      return 'Unknown';
    }
  }

  // Method to calculate total price of items in cart
  double _calculateTotalPrice() {
    double total = 0;
    for (Meal meal in Cart.allMeals) {
      total += meal.price * meal.quantity;
    }
    return total;
  }

  // Place order method
  Future<void> _placeOrder() async {
    try {
      // Fetch user name
      final userName = await _fetchUserName();
      final totalPrice = _calculateTotalPrice();

      // Fetch the last token number from the orders collection
      final lastOrder = await mongodb.ordersCollection.findOne(
        mongo.where.sortBy('timestamp', descending: true), // Get latest order
      );

      // If no last order, set token number to 1; otherwise increment the last token number
      int newTokenNumber =
          (lastOrder == null) ? 1 : (lastOrder['tokenNumber'] as int) + 1;

      // Order details object
      final orderData = {
        'tokenNumber': newTokenNumber, // New token number
        'userName': userName, // User's name
        'foodItems': Cart.allMeals
            .map((meal) => {
                  'mealName': meal.mealName,
                  'price': meal.price,
                  'quantity': meal.quantity,
                })
            .toList(), // Food items
        'totalPrice': totalPrice, // Total price
        'timestamp': DateTime.now(), // Time of order
      };

      // Insert order data into the orders collection
      await mongodb.ordersCollection.insert(orderData);

      // Clear the cart after placing the order and update token number state
      setState(() {
        Cart.clear();
        _tokenNumber = newTokenNumber; // Assign the new token number
      });

      // Show success message with token number
      _showMessage('Order placed successfully! Token number: $newTokenNumber');
    } catch (e) {
      print('Error placing order: $e');
      _showMessage('Error placing order!');
    }
  }

  void temp(Meal meal) {
    print('hi');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Meal>>(
      future: _fetchAvailableMeals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text('Error loading meals: ${snapshot.error}'));
        } else {
          final availableMeals = snapshot.data ?? [];

          Widget content;
          if (_selectedPageIndex == 0) {
            content = Categoryscreen(
              onSelectFavourite: (temp),
              availableMeals: availableMeals,
            );
          } else if (_selectedPageIndex == 1) {
            content = _buildCartContent();
          } else {
            content = _buildOrders();
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(_title),
            ),
            drawer: getDrawer(
              onchange: (identifier) => (),
            ),
            body: content,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedPageIndex,
              onTap: _selectPage,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.set_meal), label: 'Categories'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_shopping_cart), label: 'Cart'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.star), label: 'Orders'),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildOrders() {
    return FutureBuilder<String>(
      future: _fetchUserName(), // Fetch the logged-in user's name
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading user: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('User not found'));
        } else {
          final userName = snapshot.data!;

          // Fetch orders based on the userName
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: mongodb.ordersCollection
                .find(mongo.where.eq('userName', userName))
                .toList(), // Query only orders of the specific user
            builder: (context, orderSnapshot) {
              if (orderSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (orderSnapshot.hasError) {
                return Center(
                  child: Text('Error loading orders: ${orderSnapshot.error}'),
                );
              } else if (!orderSnapshot.hasData ||
                  orderSnapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No orders found for $userName.',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                final orders = orderSnapshot.data!;

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index];
                    var tokenNumber = order['tokenNumber'].toString();
                    var foodItems = order['foodItems'] as List<dynamic>;
                    var totalPrice = order['totalPrice'].toString();
                    var timestamp =
                        DateTime.parse(order['timestamp'].toString());

                    // Formatting date and time
                    var formattedDate =
                        "${timestamp.day}-${timestamp.month}-${timestamp.year}";
                    var formattedTime =
                        "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";

                    return Card(
                      color: Colors.white, // Set background color
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 2, // Shadow effect
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Preparing Order',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                Text(
                                  'Token #$tokenNumber',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 11, 11, 10)),
                                ),
                              ],
                            ),
                            Divider(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: foodItems.map<Widget>((item) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${item['mealName']} x${item['quantity']}',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                      Text(
                                        '₹${item['price']}',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Total Amount: ₹$totalPrice',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .blueAccent, // Blue color for total amount
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  Widget _buildCartContent() {
    if (Cart.allMeals.isEmpty) {
      // If cart is empty, show "Nothing here" text and a button to explore categories
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Uh oh... nothing here',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/tabs');
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              child: Text(
                'Order Food',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    } else {
      // If the cart has items, display the list of meals in the cart and place the order button
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: Cart.cartLength,
              itemBuilder: (context, index) {
                return Order(
                  meal: Cart.allMeals[index],
                  onfoodclick: (meal) {
                    // Handle food click
                  },
                  onDeleteMeal: (meal) {
                    setState(() {
                      Cart.removeMeal(meal); // Remove meal from the cart
                      _showMessage('${meal.mealName} removed from cart');
                    });
                  },
                );
              },
            ),
          ),
          // Order button
          Padding(
            padding:
                const EdgeInsets.all(16.0), // Add padding for better spacing
            child: ElevatedButton(
              onPressed: () {
                // Call the place order method
                _placeOrder();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Set button color to green
                padding: const EdgeInsets.symmetric(
                    vertical: 16), // Increase button height
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons
                      .shopping_cart_checkout), // Add an icon to the button
                  SizedBox(width: 8), // Space between icon and text
                  Text(
                    'Place Order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}
