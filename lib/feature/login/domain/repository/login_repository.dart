import 'package:j_client/j_client.dart';
import 'package:offline_engine/feature/login/data/models/login_response.dart';
import 'package:offline_engine/feature/login/domain/params/login_params.dart';

abstract class ILoginRepository {
  Future<Either<ApiFailure, LoginResponse>> login(LoginParams params);
}
