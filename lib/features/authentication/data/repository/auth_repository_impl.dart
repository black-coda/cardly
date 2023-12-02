import 'package:cardly/config/devtool/dev_tool.dart';
import 'package:cardly/features/authentication/data/datasources/remote/auth_repo.dart';
import 'package:cardly/features/authentication/domain/models/token.dart';
import 'package:cardly/features/authentication/domain/models/token_manager.dart';
import 'package:cardly/features/authentication/domain/models/user.dart';
import 'package:cardly/utils/auth_result.dart';
import 'package:cardly/utils/constant/api.dart';
import 'package:cardly/utils/extensions/dio_no_internet.dart';
import 'package:cardly/utils/interceptor/token_interceptors.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final Ref ref;
  final TokenManager tokenManager;

  // BaseOptions instance

  AuthRepositoryImpl(
      {required this.dio, required this.ref, required this.tokenManager}) {
    dio.interceptors
        .add(TokenInterceptors(ref: ref, dio: dio, tokenManager: tokenManager));
  }

  Future<void> listAllUser() async {
    try {
      final request = await dio.get(ApiKonstant.allUser);
      if (request.statusCode == 200) {
        request.data.toString().log();
      }
    } on DioException catch (e) {
      e.log();
    }
  }

  @override
  Future<Either<Failure, Success>> login(UserModel userModel) async {
    try {
      final response =
          await dio.post(ApiKonstant.login, data: userModel.toMap());

      if (response.statusCode == 200) {
        final Map<String, dynamic> tokenData = response.data;
        // data.log();
        // final tokenData = data as Map<String, String>;

        // Save token to shared preference
        final Token createdToken = Token.fromMap(tokenData);
        try {
          // tokenStorageImpl.save(createdToken);
          tokenManager.save(createdToken);
          "I have saved the token Already".log();
          return Right(
            Success(data: tokenData),
          );
        } catch (e) {
          debugPrint("Error while saving: $e");
          return Left(
            Failure(
              message: "Error while saving token: ${e.toString()}",
            ),
          );
        }

        // return right(
        //   Success<Map<String, dynamic>>(data: data),
        // );
      } else if (response.statusCode == 401) {
        debugPrint("I passed here 🚀🚀🚀");
        return Left(Failure(message: response.data));
      } else {
        debugPrint("Failure");
        // Handle other status code
        return left(
          Failure(
              message: "Login failed with status code ${response.statusCode}"),
        );
      }
    } on DioException catch (e) {
      // Handle Dio errors
      final String errorMessage = _handleDioError(e);
      errorMessage.log();
      return left(
        Failure(message: errorMessage),
      );
    } catch (e) {
      // Handle other unexpected errors
      return left(
        Failure(message: "An unexpected error occurred: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, Success>> register(UserModel userModel) async {
    try {
      // userModel.toMap().log();
      // Implement registration logic here
      "Passing through here".log();
      final response =
          await dio.post(ApiKonstant.register, data: userModel.toMap());
      if (response.statusCode == 201) {
        final Map<String, dynamic> data = response.data;
        data.log();
        return Right(
          Success(data: data),
        );
      } else if (response.statusCode == 400) {
        debugPrint("I passed here 🚀🚀🚀");
        response.data.toString().log();
        return const Left(
            Failure(message: "User with this credential already exists"));
      } else {
        debugPrint("Failure");

        return left(
          Failure(
              message:
                  "Registration failed with status code ${response.statusCode}"),
        );
      }
    } on DioException catch (e) {
      final String errorMessage = _handleDioError(e);
      return left(
        Failure(message: errorMessage),
      );
    } catch (e) {
      return left(
        Failure(message: "An unexpected error occurred: $e"),
      );
    }
  }

  // Helper method to handle Dio errors and extract meaningful error messages
  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return "Connection timeout. Please check your internet connection and try again.";
    } else if (e.type == DioExceptionType.badResponse) {
      if (e.response!.statusCode == 400) {
        // Handle bad request error
        e.response!.data.toString().log();
        return "User with this credential already exists 😪";
      }
      if (e.response!.statusCode == 401) {
        // Handle unauthorized error
        return "Unauthorized. Please check your credentials and try again.";
      }

      // Handle other response status codes as needed
      return "Request failed with status code ${e.response!.statusCode}";
    } else if (e.type == DioExceptionType.cancel) {
      return "Request cancelled";
    } else if (e.isNoConnectionError) {
      return "🤦: Unable to access the internet";
    } else {
      return "An unexpected error occurred: ${e.message}";
    }
  }

  Future<Map<String, dynamic>> getNewToken(String refreshToken) async {
    try {
      final refreshParameter = {
        "refresh": refreshToken,
      };

      final response =
          await dio.post(ApiKonstant.refresh, data: refreshParameter);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        return data;
      } else {
        // Handle other status codes
        handleError(response.statusCode!);
      }
    } on DioException catch (dioError) {
      // Handle Dio errors
      handleError(
        dioError.response?.statusCode ?? -1,
        dioError.message,
      );
    } catch (e) {
      // Handle other unexpected errors
      handleError(-1, "An unexpected error occurred: $e");
    }

    // Return an empty map or throw an exception,
    return {};
  }

  String handleError(int statusCode, [String? message]) {
    // Handle different HTTP status codes and display appropriate error messages
    switch (statusCode) {
      case 400:
        return "Bad request: $message";
      // Handling specific error for status code 400

      case 401:
        return "Unauthorized: $message";
      // Handling specific error for status code 401

      default:
        return "Request failed with status code $statusCode: $message";
    }
  }
}
