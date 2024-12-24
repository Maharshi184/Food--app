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

  // db = Db.create(MONGO_CONNECTION_URI);
  // db.open();
  // userCollection = db.collection(USER_COLLECTION);

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





// static var db, userCollection;

  // static connect() async {
  //   // Replace the connection string with your MongoDB URI
  //   db = await Db.create("mongodb+srv://maharshi:200405@cluster0.mongodb.net/FoodApp_108?retryWrites=true&w=majority");

  //   await db.open();

  //   // Replace 'users' with your collection name
  //   userCollection = db.collection('Login_credentials');
  // }

  // static Future<List<Map<String, dynamic>>> getData() async {
  //   return await userCollection.find().toList();
  // }

  // static updateData(Map<String, dynamic> query, Map<String, dynamic> updateData) async {
  //   await userCollection.update(query, updateData);
  // }

  // static deleteData(Map<String, dynamic> query) async {
  //   await userCollection.remove(query);
  // }

  // static closeConnection() async {
  //   await db.close();
  // }





// import 'package:meal/dbHelper/Constant.dart';
// import 'package:mongo_dart/mongo_dart.dart';

// const MONGO_CONNECTION_URI = "mongodb+srv://maharshi:200405@cluster0.9rfuw.mongodb.net/";
// const USER_COLLECTION="Login_data";

// class mongodb
// {
//   static var db, USER_COLLECTION;
//   static connect() async{
//     db = await  Db.create(MONGO_CONNECTION_URI);
//     await db.open();
//     USER_COLLECTION = db.collection();
    
//   }
// }

