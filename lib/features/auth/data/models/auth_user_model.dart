import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';

class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.email,
    this.isAnonymous = false,
  });
  final String id;
  final String email;
  final bool isAnonymous;

  AuthUserEntity toEntity() =>
      AuthUserEntity(id: id, email: email, isAnonymous: isAnonymous);
}
