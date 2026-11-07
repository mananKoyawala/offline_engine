import 'package:j_client/j_client.dart';
import 'package:todus/feature/login/data/models/login_response.dart';
import 'package:todus/feature/login/domain/params/login_params.dart';

abstract class ILoginRepository {
  Future<Either<ApiFailure, LoginResponse>> login(LoginParams params);
}
