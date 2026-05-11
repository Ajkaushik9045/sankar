import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String? displayName;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
  });

  factory UserModel.fromFirebase(dynamic user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  @override
  List<Object?> get props => [id, email, displayName];
}
