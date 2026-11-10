import 'package:dartz/dartz.dart';
import 'package:j_client/j_client.dart';
import 'package:todus/feature/register/data/models/otp_response.dart';
import 'package:todus/feature/register/domain/params/otp_params.dart';

abstract class IOtpRepository {
  Future<Either<ApiFailure, VerifyOtpResponse>> verifyOtp(
    VerifyOtpParams params,
  );

  Future<Either<ApiFailure, ResendOtpResponse>> resendOtp(
    ResendOtpParams params,
  );
}
