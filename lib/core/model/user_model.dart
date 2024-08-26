class UserModel {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final int? id;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? avatar;

  UserModel({
    this.firstName,
    this.lastName,
    this.avatar,
    this.id,
    this.name,
    this.email = '',
    this.password = '',
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
    return emailError == null && passwordError == null;
  }

  factory UserModel.userListfromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
