import 'package:flutter/material.dart';
import 'package:meal/Screens/mealScreen.dart';
import 'package:meal/dbHelper/mogodb.dart'; // Make sure to import your MongoDB helper
import 'package:meal/Models/meals.dart';
import 'package:meal/widget/categoryTile.dart';

class Categoryscreen extends StatefulWidget {
  final void Function(Meal meal) onSelectFavourite;
  final List<Meal> availableMeals;

  Categoryscreen(
      {required this.onSelectFavourite, required this.availableMeals});

  @override
  _CategoryscreenState createState() => _CategoryscreenState();
}

class _CategoryscreenState extends State<Categoryscreen> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

    static var foodItems;
  void fetchCategories() async {
    foodItems = await mongodb.foodCollection.find().toList();
    print(foodItems);
    Set<String> uniqueCategories = Set();

    for (var item in foodItems) {
      uniqueCategories
          .add(item['Category']); // Assuming 'Category' holds the category name
    }

    setState(() {
      categories = uniqueCategories.toList();
    });
  }

  // void _selectCategory(BuildContext context, String categoryName) {
  //   final filteredList = widget.availableMeals
  //       .where((meal) => meal.categories.contains(categoryName))
  //       .toList();
  //   print(filteredList);

  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (ctx) => Mealscreen(
  //         mealName: categoryName,
  //         meals: filteredList,
  //         onSelectFavourite: widget.onSelectFavourite,
  //       ),
  //     ),
  //   );
  // }

  void _selectCategory(BuildContext context, String categoryName) {
    // Filter food items by category from the MongoDB data
    final filteredList =
        foodItems.where((item) => item['Category'] == categoryName).toList();

    // Map filtered food items to Meal objects (if necessary)
    final List<Meal> mealsList = filteredList
        .map<Meal>((item) => Meal(
              id: item['_id'].toString(),
              mealName: item['mealName'],
              Category: [item['Category']],
              URL: item['URL'],
              price: item['price'],
              quantity: 1 // Add appropriate data
            ))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Mealscreen(
          title: categoryName,
          meals: mealsList,
          onSelectFavourite: widget.onSelectFavourite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: categories
          .map((categoryName) => CategoryTile(
                categoryName: categoryName,
                onCategorySelect: () {
                  _selectCategory(context, categoryName);
                },
              ))
          .toList(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:meal/Models/Category.dart';
// import 'package:meal/Models/meals.dart';
// import 'package:meal/Screens/mealScreen.dart';
// import 'package:meal/dummydata/dummy_data.dart';
// import 'package:meal/widget/categoryGridItem.dart';

// class Categoryscreen extends StatelessWidget {
//   Categoryscreen({super.key,required this.onSelectFavourite,required this.availableMeals});

//   final void Function(Meal meal) onSelectFavourite;
//   final List<Meal> availableMeals;

//   void _selectCategory(BuildContext context,Category category) {

//     final filteredList= availableMeals.where((meal)=>meal.categories.contains(category.id)).toList();

//     Navigator.of(context).push(
//       MaterialPageRoute(
//           builder: (ctx) => Mealscreen(mealName: category.mealName, meals: filteredList,onSelectFavourite: onSelectFavourite,),),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GridView(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 3 / 2,
//           crossAxisSpacing: 20,
//           mainAxisSpacing: 20,
//         ),
//         children: [
//           for (final Category in availableCategories)
//             Categorygriditem(
//                 category: Category,
//                 onCategorySelect: () {
//                   _selectCategory(context,Category);
//                 })
//         ],
//     );
//   }
// }
