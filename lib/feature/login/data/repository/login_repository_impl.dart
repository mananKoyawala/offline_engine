import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:todus/core/api_clients.dart';
import 'package:todus/core/endpoints.dart';
import 'package:todus/feature/login/data/models/login_response.dart';
import 'package:todus/feature/login/domain/params/login_params.dart';
import 'package:todus/feature/login/domain/repository/login_repository.dart';

@LazySingleton(as: ILoginRepository)
class LoginRepositoryImpl extends ILoginRepository {
  final APIClients _clients;

  LoginRepositoryImpl({required this._clients});
  @override
  Future<Either<ApiFailure, LoginResponse>> login(LoginParams params) async {
    return await _clients.offlineEngine.post(
      LoginEndpoints.login,
      data: params.toJson(),
      parser: LoginResponse.fromJson,
    );
  }
}
