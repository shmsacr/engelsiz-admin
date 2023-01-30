import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engelsiz_admin/data/models/user.dart' as app_user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final fireStoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final userChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).userChanges());

final userProvider = Provider<User?>((ref) {
  ref.watch(userChangesProvider);
  return ref.watch(firebaseAuthProvider.select((value) => value.currentUser));
});

@JsonEnum(valueField: 'value')
enum Gender {
  male("Erkek"),
  female("Kadın");

  const Gender(this.value);
  final String value;
}

@JsonEnum(valueField: 'value')
enum Role {
  admin("Yönetici"),
  teacher("Öğretmen"),
  parent("Veli");

  const Role(this.value);
  final String value;
}

Future<void> signUp(
    {required WidgetRef ref, required app_user.User user}) async {
  final UserCredential userCredential = await ref
      .read(firebaseAuthProvider)
      .createUserWithEmailAndPassword(email: user.email, password: user.tc);
  await userCredential.user?.updateDisplayName(user.fullName);
  await ref
      .read(fireStoreProvider)
      .collection("users")
      .doc(userCredential.user?.uid)
      .set(user.map(
          teacher: (teacher) => teacher.toJson(),
          parent: (parent) => parent.toJson()));
  debugPrint("User created w/ id: ${userCredential.user?.uid}");
}
