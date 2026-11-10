import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:todus/feature/account/data/models/delete_account_response.dart';
import 'package:todus/feature/account/domain/params/delete_account_params.dart';
import 'package:todus/feature/account/domain/repository/account_repository.dart';

@lazySingleton
class AccountUsecases {
  final IAccountRepository _accountRepository;

  AccountUsecases({required this._accountRepository});

  Future<Either<ApiFailure, DeleteAccountResponse>> requestAccountDeletion(
    DeleteAccountParams params,
  ) async {
    return await _accountRepository.requestAccountDeletion(params);
  }
}
