import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  final String tokenNumber;
  final String userName;
  final List<Map<String, dynamic>>
      itemDetails; // List of items with mealName, price, quantity
  final String totalPrice;
  final bool isCompleted;

  const OrderCard({
    Key? key,
    required this.tokenNumber,
    required this.userName,
    required this.itemDetails,
    required this.totalPrice,
    this.isCompleted = false, // Default checkbox state
  }) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Token label
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Token: #${widget.tokenNumber}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // User details with icon
            Row(
              children: [
                Icon(
                  Icons
                      .person, // Replaces the profile circle with a person icon
                  color: Colors.blue,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  widget.userName,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Display each item in a horizontal row
            Column(
              children: widget.itemDetails.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Meal name (expanded to take the available space)
                      Expanded(
                        flex: 2,
                        child: Text(
                          item['mealName'],
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),

                      // Quantity with a circle background
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'x${item['quantity']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Price (aligned right)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '₹${item['price']}',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),

            // Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '₹${widget.totalPrice}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Mark complete button with checkbox
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Mark Complete Button
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isChecked = !_isChecked;
                    });
                  },
                  icon: Icon(Icons.check, color: Colors.white),
                  label: Text(
                    _isChecked ? 'Completed' : 'Mark Complete',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
