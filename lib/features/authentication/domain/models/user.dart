// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String email;
  final String password;
  final String? password2;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;

  UserModel({
    required this.email,
    required this.password,
    this.password2,
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });

  @override
  String toString() {
    return 'UserModel(email: $email, password: $password, password2: $password2, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'password2': password2,
      'first_name': firstName,
      'last_name': lastName,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      password: map['password'] as String,
      password2: map['password2'] != null ? map['password2'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.password == password &&
      other.password2 == password2 &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      password.hashCode ^
      password2.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      phoneNumber.hashCode;
  }

  UserModel copyWith({
    String? email,
    String? password,
    String? password2,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
      password2: password2 ?? this.password2,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
