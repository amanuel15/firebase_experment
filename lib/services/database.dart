import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;

  // collection reference
  final CollectionReference productsCollection = Firestore.instance.
      collection('products');

  DatabaseService({this.uid});
  
  Future updateUserData(String name, double price, int amount) async {
    return await productsCollection.document(uid).setData({
      'name': name,
      'price': price,
      'amount': amount,
    });
  }

}