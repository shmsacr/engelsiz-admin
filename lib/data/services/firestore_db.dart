import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabase {
  FirestoreDatabase({this.uid});
  final String? uid;

  final FirebaseFirestore service = FirebaseFirestore.instance;
  get _usersRef => service.collection("users").doc(uid);

  Future<Map<String, dynamic>> sa() async {
    final asa = await _usersRef.get();
    return asa.data();
  }
}
