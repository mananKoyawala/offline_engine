import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/feature/login/data/models/login_response.dart';
import 'package:offline_engine/feature/login/domain/params/login_params.dart';
import 'package:offline_engine/feature/login/domain/repository/login_repository.dart';

@lazySingleton
class LoginUsecases {
  final ILoginRepository _loginRepository;

  LoginUsecases({required this._loginRepository});

  Future<Either<ApiFailure, LoginResponse>> call(LoginParams params) async {
    return await _loginRepository.login(params);
  }
}
