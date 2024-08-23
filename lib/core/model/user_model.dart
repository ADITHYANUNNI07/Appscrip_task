class UserModel {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;

  UserModel({
    required this.email,
    required this.password,
    this.emailError,
    this.passwordError,
  });

  UserModel copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
    );
  }

  bool get isValid {
    return emailError == '' && passwordError == '';
  }
}
