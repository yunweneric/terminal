class Transaction {
  final String name;
  final String? photoUrl;
  final int amount;
  final DateTime createdAt;

  Transaction({required this.amount, required this.createdAt, required this.name, this.photoUrl});
}
