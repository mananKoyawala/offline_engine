import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:todus/feature/register/data/models/otp_response.dart';
import 'package:todus/feature/register/domain/params/otp_params.dart';
import 'package:todus/feature/register/domain/repository/otp_repository.dart';

@lazySingleton
class OtpUsecases {
  final IOtpRepository _otpRepository;

  OtpUsecases({required this._otpRepository});

  Future<Either<ApiFailure, VerifyOtpResponse>> verifyOtp(
    VerifyOtpParams params,
  ) async {
    return await _otpRepository.verifyOtp(params);
  }

  Future<Either<ApiFailure, ResendOtpResponse>> resendOtp(
    ResendOtpParams params,
  ) async {
    return await _otpRepository.resendOtp(params);
  }
}
