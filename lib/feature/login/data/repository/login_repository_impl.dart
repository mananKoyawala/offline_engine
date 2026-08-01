import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/api_clients.dart';
import 'package:offline_engine/core/endpoints.dart';
import 'package:offline_engine/feature/login/data/models/login_response.dart';
import 'package:offline_engine/feature/login/domain/params/login_params.dart';
import 'package:offline_engine/feature/login/domain/repository/login_repository.dart';

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
