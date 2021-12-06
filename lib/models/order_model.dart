class Order {
  String name;
  String uid;
  String orderNo;
  String id;
  String status;
  int local;
  int continental;
  String address;
  String note;
  String phone;
  String time;
  String fcmToken;
  int rating;
  String? review;
  String? reason;
  int amount;

  Order({
    required this.name,
    required this.uid,
    required this.orderNo,
    required this.id,
    required this.status,
    required this.local,
    required this.continental,
    required this.address,
    required this.note,
    required this.phone,
    required this.time,
    required this.fcmToken,
    required this.rating,
    required this.review,
    this.reason,
    required this.amount,
  });
}