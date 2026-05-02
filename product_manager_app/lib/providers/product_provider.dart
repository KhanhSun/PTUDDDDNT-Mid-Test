import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ProductModel> products = [];

  bool isLoading = false;

  Future<void> fetchProducts() async {
    try {
      isLoading = true;
      notifyListeners();

      final snapshot = await _firestore.collection('products').get();

      products = snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(ProductModel product) async {
    await _firestore.collection('products').add(product.toMap());

    await fetchProducts();
  }

  Future<void> updateProduct(ProductModel product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toMap());

    await fetchProducts();
  }

  Future<void> deleteProduct(String id) async {
    await _firestore.collection('products').doc(id).delete();

    await fetchProducts();
  }
}
