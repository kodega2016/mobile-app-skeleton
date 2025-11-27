import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> checkAuthStatus();

  Future<Either<Failure, UserEntity>> getCurrentUser();
}