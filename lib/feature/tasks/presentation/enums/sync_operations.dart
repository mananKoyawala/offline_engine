enum SyncOperations {
  create("create"),
  delete("delete"),
  update("update");

  final String type;

  const SyncOperations(this.type);

  static SyncOperations fromValue(String type) {
    return SyncOperations.values.firstWhere(
      (e) => e.type == type,
      orElse: () => SyncOperations.create,
    );
  }
}

enum SyncStatus {
  pending("pending"),
  failed("failed"),
  success("success"),
  merged("merged"),
  autoResolved("autoResolved");

  final String status;

  const SyncStatus(this.status);

  static SyncStatus fromValue(String status) {
    return SyncStatus.values.firstWhere(
      (e) => e.status == status,
      orElse: () => SyncStatus.failed,
    );
  }
}
