import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class CheckAuthUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  CheckAuthUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.checkAuthStatus();
  }
}