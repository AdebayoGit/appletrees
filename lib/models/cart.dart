import 'package:flutter/foundation.dart';

import 'meal_model.dart';

class Cart extends ChangeNotifier{

  Set<Meal> cart = {};

  int local = 0;

  int continental = 0;

  void addToCart(Meal meal){
    bool isAdded = false;
    for (var element in cart) {
      if(element.mealId == meal.mealId){
        isAdded = true;
      }
    }
    if(!isAdded){
      cart.add(meal);
      increase(meal);
      notifyListeners();
    }
  }

  void removeFromCart(Meal meal){
    cart.remove(meal);
    notifyListeners();
  }

  void increase(Meal meal){
    if(meal.mealType.toLowerCase() == 'africana'){
      local++;
    } else{
      continental++;
    }
    notifyListeners();
  }

  void decrease(Meal meal){
    if(meal.mealType.toLowerCase() == 'africana' && local > 1){
      local--;
    } else if (continental > 1){
      continental--;
    }
    notifyListeners();
  }
}