import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:todus/core/api_clients.dart';
import 'package:todus/core/endpoints.dart';
import 'package:todus/feature/register/data/models/register_response.dart';
import 'package:todus/feature/register/domain/params/register_params.dart';
import 'package:todus/feature/register/domain/repository/register_repository.dart';

@LazySingleton(as: IRegisterRepository)
class RegisterRepositoryImpl extends IRegisterRepository {
  final APIClients _clients;

  RegisterRepositoryImpl({required this._clients});

  @override
  Future<Either<ApiFailure, RegisterResponse>> register(
    RegisterParams params,
  ) async {
    return await _clients.offlineEngine.post(
      RegisterEndpoints.register,
      data: params.toJson(),
      parser: RegisterResponse.fromJson,
    );
  }
}
