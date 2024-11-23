// cart.dart
import 'package:meal/Models/meals.dart';

class Cart {
  static List<Meal> cartMeals = [];
  

  static void addMeal(Meal meal) {
    cartMeals.add(meal);
  }

  static void removeMeal(Meal meal) {
    cartMeals.remove(meal);
  }

  static int get cartLength => cartMeals.length;

  static List<Meal> get allMeals => cartMeals; // Getter to access all meals
  static void clear() {
    cartMeals.clear();
  }
  
}
