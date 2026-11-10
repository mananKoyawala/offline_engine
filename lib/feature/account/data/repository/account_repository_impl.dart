import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:todus/core/api_clients.dart';
import 'package:todus/core/endpoints.dart';
import 'package:todus/feature/account/data/models/delete_account_response.dart';
import 'package:todus/feature/account/domain/params/delete_account_params.dart';
import 'package:todus/feature/account/domain/repository/account_repository.dart';

@LazySingleton(as: IAccountRepository)
class AccountRepositoryImpl extends IAccountRepository {
  final APIClients _clients;

  AccountRepositoryImpl({required this._clients});

  @override
  Future<Either<ApiFailure, DeleteAccountResponse>> requestAccountDeletion(
    DeleteAccountParams params,
  ) async {
    return await _clients.offlineEngine.post(
      AccountEndpoints.deletionRequest,
      data: params.toJson(),
      parser: DeleteAccountResponse.fromJson,
    );
  }
}
