import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:longthroat_customer/models/meal_model.dart';


class MealServices {


  final CollectionReference shopCollection =
  FirebaseFirestore.instance.collection('shop');

  // All meals' list created from snapshot
  List<Meal> _allMeals(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Meal(
        mealName: doc['name'] ?? '',
        mealType: doc['type'] ?? '',
        mealDesc: doc['desc'] ?? '',
        mealImage: doc['imageUrl'] ?? '',
        mealId: doc.reference.id,
        mealPrice: int.parse(doc['price']),
      );
    }).toList();
  }

  // All meals from shop
  Stream<List<Meal>> get shop {
    return shopCollection.snapshots().map(_allMeals);
  }
}