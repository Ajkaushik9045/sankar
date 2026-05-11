import 'package:sankar/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signUp({required String email, required String password});
  Future<UserModel> login({required String email, required String password});
  Future<void> logout();
  Stream<UserModel?> get user;
}
