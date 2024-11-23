// import 'package:flutter/material.dart';
// import 'package:meal/Models/meals.dart';

// class Foodscreen extends StatelessWidget {
//   Foodscreen({super.key, required this.meal, required this.onSelectFavourite});
//   final Meal meal;
//   final void Function(Meal meal) onSelectFavourite;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(meal.title),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 onSelectFavourite(meal);
//               },
//               icon: Icon(Icons.star),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.network(
//                 meal.imageUrl,
//                 height: 300,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//               const SizedBox(
//                 height: 14,
//               ),
//               Text(
//                 'ingredients: ${meal.ingredients}',
//                 style: const TextStyle(color: Colors.white),
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               const Text(
//                 'steps',
//                 style: TextStyle(
//                     fontSize: 22,
//                     color: Color.fromARGB(
//                       255,
//                       204,
//                       90,
//                       90,
//                     )),
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               for (final step in meal.steps)
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                   child: Text(
//                     step,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//             ],
//           ),
//         ));
//   }
// }
