import 'package:dartz/dartz.dart';
import 'package:j_client/j_client.dart';
import 'package:todus/feature/register/data/models/register_response.dart';
import 'package:todus/feature/register/domain/params/register_params.dart';

abstract class IRegisterRepository {
  Future<Either<ApiFailure, RegisterResponse>> register(RegisterParams params);
}
