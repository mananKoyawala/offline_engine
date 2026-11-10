class DeleteAccountParams {
  final String reason;

  DeleteAccountParams({required this.reason});

  Map<String, dynamic> toJson() => {'reason': reason};
}
