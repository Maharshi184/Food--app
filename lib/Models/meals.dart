import 'package:mongo_dart/mongo_dart.dart';

enum Complexity {
  simple,
  challenging,
  hard,
}

enum Affordability {
  affordable,
  pricey,
  luxurious,
}

class Meal {
   Meal({
    required this.id,
    required this.Category,
    required this.mealName,
    required this.URL,
    required this.price,
    required this.quantity
  });

  final String id;
  final List<String> Category;
  final String mealName;
  final String URL;
  // final List<String> ingredients;
  // final List<String> steps;
  final int price;
    int quantity;
  // final Complexity complexity;
  // final Affordability affordability;
  // final bool isGlutenFree;
  // final bool isLactoseFree;
  // final bool isVegan;
  // final bool isVegetarian;

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: (map['_id'] as ObjectId).toHexString(),
      Category: map['Category'] is List
          ? List<String>.from(map['Category'])
          : [map['Category'] as String],
      mealName: map['mealName'] as String,
      URL: map['URL'] as String,
      price: (map['price'] as num).toInt(),
      quantity: 1 // Convert to int if it's a num
    );
  }

  // factory Meal.fromList(List<dynamic> list) {
  //   return Meal(
  //     id: (list[0] as ObjectId)
  //         .toHexString(), // Assuming first item is ObjectId
  //     Category: list[1] is List
  //         ? List<String>.from(list[1]) // If it's a list of categories
  //         : [list[1] as String], // If it's a single category
  //     mealName: list[2] as String, // Assuming third item is mealName
  //     URL: list[3] as String, // Assuming fourth item is URL
  //     price: list[4] as int, // Assuming fifth item is price
  //   );
  // }
}
