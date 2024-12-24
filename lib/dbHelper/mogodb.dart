import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

const MONGO_CONNECTION_URI =
    "mongo_cluster_url";
const USER_COLLECTION = "Login_data";

class mongodb {
  static var db,
      userCollection,
      foodCollection,
      ordersCollection,
      ownerCollection;

  static connect() async {
    // Replace the connection string with your MongoDB URI
    db = await Db.create(MONGO_CONNECTION_URI);

    await db.open();

    // Replace 'users' with your collection name
    userCollection = db.collection('Login_data');
    foodCollection = db.collection('FoodItems');
    ordersCollection = db.collection('Orders');
    ownerCollection = db.collection('Owner');

    print('DB connected');
  }

  static insertData(Map<String, dynamic> data) async {
    try {
      await userCollection.insert(data);
      print('Data successfully inserted into MongoDB');
    } catch (e) {
      print('Error during insertion: $e');
    }
  }

  static ShowFooddata() async {
    try {
      // Fetch all documents from the collection
      var foodItems = await foodCollection.find().toList();

      // Print each document
      for (var item in foodItems) {
        print(item); // Prints the entire document
      }
    } catch (e) {
      print('Error fetching food items: $e');
    }
  }

  // Fetch distinct categories from FoodItems collection
  static Future<List<String>> fetchCategories() async {
    try {
      var categories = await foodCollection.distinct('Category');
      return categories.cast<String>();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Fetch food items based on the selected category
  static Future<List<Map<String, dynamic>>> fetchFoodItems(
      String categoryId) async {
    try {
      var foodItems =
          await foodCollection.find({'Category': categoryId}).toList();
      return foodItems;
    } catch (e) {
      print('Error fetching food items: $e');
      return [];
    }
  }
}






  
