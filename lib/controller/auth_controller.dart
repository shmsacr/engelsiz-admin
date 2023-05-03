import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engelsiz_admin/data/models/class_room.dart' as app_class;
import 'package:engelsiz_admin/data/models/classroom_with_id.dart';
import 'package:engelsiz_admin/data/models/user.dart' as app_user;
import 'package:engelsiz_admin/data/models/user_with_id.dart';
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

@JsonEnum(valueField: 'name')
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
  addClass(user, ref, userCredential);
  await ref
      .read(fireStoreProvider)
      .collection("users")
      .doc(userCredential.user?.uid)
      .set(user.map(
          teacher: (teacher) => teacher.toJson(),
          parent: (parent) => parent.toJson()));
  debugPrint("User created w/ id: ${userCredential.user?.uid}");
}

Future<void> addClass(
    app_user.User user, WidgetRef ref, UserCredential userCredential) async {
  bool isTeacher = false;
  user.map(teacher: (_) => isTeacher = true, parent: (_) => {});
  for (var element in user.classroom) {
    await ref
        .read(fireStoreProvider)
        .collection('classRooms')
        .doc(element)
        .update(isTeacher
            ? {
                'teachers': FieldValue.arrayUnion([userCredential.user?.uid])
              }
            : {
                'parents': FieldValue.arrayUnion([userCredential.user?.uid])
              });
  }
}

Future<void> createClass(
    {required WidgetRef ref, required app_class.Classroom classRoom}) async {
  await ref
      .read(fireStoreProvider)
      .collection('classRooms')
      .doc()
      .set(classRoom.toJson());
}

final usersStreamProvider = StreamProvider.autoDispose<List<UserWithId>>((ref) {
  final stream = ref.watch(fireStoreProvider).collection("users").snapshots();
  return stream.map((snapshot) => snapshot.docs.map((doc) {
        return UserWithId(id: doc.id, user: app_user.User.fromJson(doc.data()));
      }).toList());
});

final classStreamProvider =
    StreamProvider.autoDispose<List<ClassroomWithId>>((ref) {
  final stream =
      ref.watch(fireStoreProvider).collection('classRooms').snapshots();
  return stream.map((snapshot) => snapshot.docs.map((doc) {
        return ClassroomWithId(
            id: doc.id, classRoom: app_class.Classroom.fromJson(doc.data()));
      }).toList());
});
