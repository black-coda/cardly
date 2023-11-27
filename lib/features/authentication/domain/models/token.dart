// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class Token {
   final String refreshToken;
   final String accessToken;
  Token({
    required this.refreshToken,
    required this.accessToken,
  });

  Token copyWith({
    String? refreshToken,
    String? accessToken,
  }) {
    return Token(
      refreshToken: refreshToken ?? this.refreshToken,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'refresh': refreshToken,
      'access': accessToken,
    };
  }

  factory Token.fromMap(Map<String, dynamic> map) {
    return Token(
      refreshToken: map['refresh'] as String,
      accessToken: map['access'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Token.fromJson(String source) => Token.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Token(refreshToken: $refreshToken, accessToken: $accessToken)';

  @override
  bool operator ==(covariant Token other) {
    if (identical(this, other)) return true;
  
    return 
      other.refreshToken == refreshToken &&
      other.accessToken == accessToken;
  }

  @override
  int get hashCode => refreshToken.hashCode ^ accessToken.hashCode;
}
