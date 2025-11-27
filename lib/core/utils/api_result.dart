import 'package:dartz/dartz.dart';

import 'failure.dart';

// Type alias for Either with Failure on the left
typedef ApiResult<T> = Either<Failure, T>;

// Extension methods for cleaner syntax
extension ApiResultX<T> on ApiResult<T> {
  bool get isSuccess => isRight();
  bool get isFailure => isLeft();

  T? get data => fold(
        (failure) => null,
        (data) => data,
      );

  Failure? get error => fold(
        (failure) => failure,
        (data) => null,
      );
}

// Helper methods to create results
ApiResult<T> success<T>(T data) => Right(data);
ApiResult<T> failure<T>(Failure error) => Left(error);