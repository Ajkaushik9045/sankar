import 'package:firebase_auth/firebase_auth.dart';
import 'package:sankar/features/auth/domain/repositories/auth_repository.dart';
import 'package:sankar/features/auth/data/models/user_model.dart';
import 'package:sankar/core/error/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser != null ? UserModel.fromFirebase(firebaseUser) : null;
    });
  }

  @override
  Future<UserModel> signUp({required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw const AuthFailure('User creation failed');
      }
      return UserModel.fromFirebase(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'An error occurred during sign up');
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<UserModel> login({required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw const AuthFailure('Login failed');
      }
      return UserModel.fromFirebase(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'An error occurred during login');
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
