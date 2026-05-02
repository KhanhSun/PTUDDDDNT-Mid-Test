import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? userModel;

  bool isLoading = false;

  Future<void> fetchUser() async {
    final uid = _auth.currentUser!.uid;

    final doc = await _firestore.collection('users').doc(uid).get();

    if (doc.exists) {
      userModel = UserModel.fromMap(doc.data()!);

      notifyListeners();
    }
  }

  Future<String> uploadImage(File imageFile) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(DateTime.now().millisecondsSinceEpoch.toString());

    if (kIsWeb) {
      final bytes = await imageFile.readAsBytes();

      await ref.putData(bytes);
    } else {
      await ref.putFile(File(imageFile.path));
    }

    return await ref.getDownloadURL();
  }

  Future<void> updateProfile({
    required String name,
    required String imageUrl,
  }) async {
    final uid = _auth.currentUser!.uid;

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': _auth.currentUser!.email,
      'imageUrl': imageUrl,
    });

    await fetchUser();

    notifyListeners();
  }
}
