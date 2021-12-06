import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:longthroat_customer/models/order_model.dart';
import 'package:longthroat_customer/utilities/global_variables.dart';

class OrderServices {

  final String userId = currentUser.uid;

  // collection reference
  final CollectionReference ordersCollection =
  FirebaseFirestore.instance.collection('orders');

  // All orders from orders snapshot
  List<Order> _allOrders(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Order(
        id: doc.id,
        name: "${doc['name']}",
        status: "${doc['status']}",
        uid: "${doc['added_by']}",
        local: doc['local'],
        continental: doc['continental'],
        address: "${doc['address']}",
        note: "${doc['note']}",
        phone: "${doc['phone']}",
        time: doc['time'],
        fcmToken: "${doc['fcmToken']}",
        reason: doc['reason'] ?? '',
        rating: doc['rating'] ?? 0,
        review: doc['review'] ?? '',
        orderNo: doc['order_no'],
        amount: doc['total_cost'],
      );
    }).toList();
  }


  Stream<List<Order>> orders (String status){
    print(userId);
    return ordersCollection.where('added_by', isEqualTo: userId).where('status', isEqualTo: status).snapshots().map(_allOrders);
    
  }
}
