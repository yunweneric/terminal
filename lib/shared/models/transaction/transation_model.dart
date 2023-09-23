class AppTransaction {
  final String name;
  final String id;
  final int amount;
  final DateTime createdAt;

  AppTransaction({required this.amount, required this.createdAt, required this.name, required this.id});
}
