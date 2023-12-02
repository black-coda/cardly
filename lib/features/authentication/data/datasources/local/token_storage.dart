import 'package:cardly/features/authentication/domain/models/token.dart';

abstract class TokenStorage {
  Future<Token?> read();
  Future<Token?> refresh();
  Future<void> save(Token token);
  Future<void> destroy();
}
