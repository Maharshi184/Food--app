import 'package:flutter/material.dart';
import 'package:meal/Models/Category.dart';
import 'package:meal/dbHelper/mogodb.dart';
import 'package:meal/widget/OrderListCard.dart';
import 'package:meal/widget/drawer.dart'; // Import the OrderCard widget

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders(); // Fetch orders when the screen initializes
  }

  Future<void> _fetchOrders() async {
    try {
      // Fetch the data from MongoDB (mongodb.ordersCollection as per your helper)
      var orders = await mongodb.ordersCollection.find().toList();
      print('Raw MongoDB data: $orders');
      print(orders[0]);

      setState(() {
        _orders = orders;
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
      ),
      drawer: getDrawer(
        onchange: (identifier) => (),
      ),
      body: _orders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                var order = _orders[index];

                // Extract necessary fields from the order
                var tokenNumber =
                    order['tokenNumber']?.toString() ?? 'N/A'; // Add null check
                var userName = order['userName'] ?? 'Unknown'; // Add null check
                var foodItems = order['foodItems'] as List<dynamic>? ??
                    []; // Add null check and fallback to empty list
                num totalPrice = 0;

                // Combine item details if foodItems is not empty
                List<Map<String, dynamic>> itemDetails = [];
                for (var item in foodItems) {
                  itemDetails.add({
                    'mealName': item['mealName'],
                    'quantity': item['quantity'],
                    'price': item['price']
                  });
                  totalPrice = order[
                      'totalPrice'];
                 // Calculate total price, ensuring it's not null
                }

                return OrderCard(
                  tokenNumber: tokenNumber,
                  userName: userName,
                  itemDetails: itemDetails, // Pass item details list
                  totalPrice: totalPrice.toString(),
                  isCompleted: order['isCompleted'] ?? false,
                );
              },
            ),
    );
  }
}
