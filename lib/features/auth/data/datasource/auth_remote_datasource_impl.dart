import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.auth,
    required this.firestore,
  });

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;

    final userModel = UserModel(
      id: user.uid,
      name: name,
      email: email,
      phone: phone,
      role: 'passenger',
      walletBalance: 0.0,
      isVerified: false,
    );

    await firestore.collection('users').doc(user.uid).set(userModel.toMap());

    return userModel;
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final doc = await firestore.collection('users').doc(uid).get();

    return UserModel.fromMap(doc.data()!);
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = auth.currentUser;

    if (user == null) return null;

    final doc = await firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!);
  }
}