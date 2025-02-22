import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/models/run.dart';
import 'package:runningapp/state/backend/authenticator.dart';

class Database {
  final FirebaseFirestore firestore;
  final Authenticator auth = Authenticator();

  Database({required this.firestore});

  Future<void> addDocument(String collection, Map<String, dynamic> data) {
    return firestore.collection(collection).add(data);
  }

  Stream<QuerySnapshot> streamCollection(String collection) {
    return firestore.collection(collection).snapshots();
  }

  // Add other methods for update, delete, etc.

  // Add user
  Future<void> addUser(String collection, Map<String, dynamic> data) async {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }
    debugPrint(userId);
    await firestore.collection(collection).doc(userId).set(data);
  }

  // Add run
  Future<void> addRun(String collection, Run run) async {
    final userId = auth.userId;
    // debugPrint(userId);
    if (userId == null) {
      throw Exception("User not logged in");
    }
    final ref = firestore
        .collection("users")
        .doc(userId)
        .collection("runs")
        .withConverter(
            fromFirestore: Run.fromFirestore,
            toFirestore: (Run run, options) => run.toFirestore())
        .doc();
    final id = ref.id;
    Run newRun = run.copyWith(id: id);
    await ref.set(newRun);
  }

  // Get runs
  Future<QuerySnapshot> getRuns(String userId, String collection) {
    return firestore
        .collection("users")
        .doc(userId)
        .collection(collection)
        .get();
  }
}
