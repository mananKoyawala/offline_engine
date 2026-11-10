import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:todus/core/api_clients.dart';
import 'package:todus/core/endpoints.dart';
import 'package:todus/feature/register/data/models/otp_response.dart';
import 'package:todus/feature/register/domain/params/otp_params.dart';
import 'package:todus/feature/register/domain/repository/otp_repository.dart';

@LazySingleton(as: IOtpRepository)
class OtpRepositoryImpl extends IOtpRepository {
  final APIClients _clients;

  OtpRepositoryImpl({required this._clients});

  @override
  Future<Either<ApiFailure, VerifyOtpResponse>> verifyOtp(
    VerifyOtpParams params,
  ) async {
    return await _clients.offlineEngine.post(
      OtpEndpoints.verifyOtp,
      data: params.toJson(),
      parser: VerifyOtpResponse.fromJson,
    );
  }

  @override
  Future<Either<ApiFailure, ResendOtpResponse>> resendOtp(
    ResendOtpParams params,
  ) async {
    return await _clients.offlineEngine.post(
      OtpEndpoints.resendOtp,
      data: params.toJson(),
      parser: ResendOtpResponse.fromJson,
    );
  }
}
