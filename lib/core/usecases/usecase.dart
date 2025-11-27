import 'package:dartz/dartz.dart';

import '../utils/failure.dart';

/// Base class for all use cases
/// [Type] is the return type
/// [Params] is the parameters type
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// For use cases that don't need parameters
class NoParams {}

/// For use cases that need pagination
class PaginationParams {
  final int page;
  final int limit;

  const PaginationParams({
    required this.page,
    required this.limit,
  });
}