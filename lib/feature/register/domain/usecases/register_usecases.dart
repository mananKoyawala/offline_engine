import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:todus/feature/register/data/models/register_response.dart';
import 'package:todus/feature/register/domain/params/register_params.dart';
import 'package:todus/feature/register/domain/repository/register_repository.dart';

@lazySingleton
class RegisterUsecases {
  final IRegisterRepository _registerRepository;

  RegisterUsecases({required this._registerRepository});

  Future<Either<ApiFailure, RegisterResponse>> call(
    RegisterParams params,
  ) async {
    return await _registerRepository.register(params);
  }
}
