import 'package:dartz/dartz.dart';
import 'package:j_client/j_client.dart';
import 'package:todus/feature/account/data/models/delete_account_response.dart';
import 'package:todus/feature/account/domain/params/delete_account_params.dart';

abstract class IAccountRepository {
  Future<Either<ApiFailure, DeleteAccountResponse>> requestAccountDeletion(
    DeleteAccountParams params,
  );
}
