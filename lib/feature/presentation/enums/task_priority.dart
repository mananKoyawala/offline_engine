enum TaskPriority {
  low(-1),
  medium(0),
  high(1);

  final int value;

  const TaskPriority(this.value);

  static TaskPriority fromValue(int value) {
    return TaskPriority.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TaskPriority.medium,
    );
  }
}
