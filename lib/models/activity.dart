class Activity {
  final String title;

  final String subtitle;

  final double amount;

  final DateTime date;

  final bool isExpense;

  const Activity({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.isExpense,
  });
}