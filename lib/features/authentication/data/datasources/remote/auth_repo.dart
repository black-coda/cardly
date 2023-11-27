import 'package:cardly/features/authentication/domain/models/user.dart';
import 'package:cardly/utils/auth_result.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, Success>> login(UserModel userModel);
  Future<Either<Failure, Success>> register(UserModel userModel);
}
