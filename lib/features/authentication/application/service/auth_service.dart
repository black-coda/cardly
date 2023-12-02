import 'package:cardly/config/devtool/dev_tool.dart';
import 'package:cardly/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:cardly/features/authentication/data/repository/token_storage_impl.dart';
import 'package:cardly/features/authentication/domain/models/token.dart';
import 'package:cardly/features/authentication/domain/models/token_manager.dart';
import 'package:cardly/features/authentication/domain/models/user.dart';
import 'package:cardly/utils/auth_result.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class AuthService {
  final AuthRepositoryImpl authRepositoryImpl;
 
  final TokenManager tokenManager;

  AuthService({
    required this.authRepositoryImpl,
    required this.tokenManager,
  });




  Future<Either<Failure, Success>> logUserIn(UserModel userModel) async {
    try {
      final request = await authRepositoryImpl.login(userModel);
     request.fold(
        (Failure failure) {
          return Left(failure);
        },
        (success) {
          if (success.data is Map<String, String>) {
            debugPrint(success.data.toString());
            final tokenData = success.data as Map<String, String>;

            // Save token to shared preference
            final Token createdToken = Token.fromMap(tokenData);
            try {
              // tokenStorageImpl.save(createdToken);
              tokenManager.save(createdToken);
              "I have saved the token Already".log();
              return Right(
                Success(data: createdToken),
              );
            } catch (e) {
              debugPrint("Error while saving: $e");
              return Left(
                Failure(
                  message: "Error while saving token: ${e.toString()}",
                ),
              );
            }
          } else {
            return const Left(
              Failure(message: "Unexpected data format"),
            );
          }
        },
      );

      //! Pleas contniue from here

      return request;
    } catch (e) {
      e.log();
      return Left(
        Failure(
          message: "An unexpected error occurred: $e",
        ),
      );
    }
  }

  Future<Either<Failure, Success>> register(UserModel userModel) async {
    try {
      final request = await authRepositoryImpl.register(userModel);
      request.fold(
        (failure) {
          return Left(failure);
        },
        (success) {
          return Right(success);
        },
      );
      return request;
    } catch (e) {
      return Left(
        Failure(message: "An unexpected error occurred: ${e.toString()}"),
      );
    }
  }
}
