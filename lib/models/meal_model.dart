class Meal {
  String mealId;
  String mealName;
  String mealType;
  int mealPrice;
  String mealImage;
  String mealDesc;

  Meal({
    required this.mealType,
    required this.mealName,
    required this.mealId,
    required this.mealPrice,
    required this.mealDesc,
    required this.mealImage
  });
}